view: prediction_analysis {
  # --- 1. DERIVED TABLE (The Bucketing Logic) ---
  # This SQL query runs first to group the raw data
  derived_table: {
    sql:
      SELECT
        CASE
          WHEN delay_risk_score BETWEEN 0 AND 20 THEN '1. Low Risk (0-20%)'
          WHEN delay_risk_score BETWEEN 20.01 AND 60 THEN '2. Medium Risk (21-60%)'
          WHEN delay_risk_score BETWEEN 60.01 AND 80 THEN '3. High Risk (61-80%)'
          WHEN delay_risk_score > 80 THEN '4. Critical Risk (>80%)'
          ELSE 'Unknown'
        END AS risk_bucket,
        COUNT(*) as total_volume,
        SUM(is_late) as actual_late_count
      FROM nexus_db.shipments
      GROUP BY 1
      ;;
  }

  # --- 2. DIMENSIONS (The Buckets) ---
  dimension: risk_bucket {
    type: string
    sql: ${TABLE}.risk_bucket ;;
    description: "Grouped risk levels to validate AI accuracy"
  }

  dimension: total_volume {
    type: number
    sql: ${TABLE}.total_volume ;;
    hidden: yes # Hide raw numbers, show measures instead
  }

  dimension: actual_late_count {
    type: number
    sql: ${TABLE}.actual_late_count ;;
    hidden: yes
  }

  # --- 3. MEASURES (The Accuracy Metrics) ---

  # Count of shipments in each bucket
  measure: bucket_count {
    type: sum
    sql: ${total_volume} ;;
    label: "Total Shipments in Bucket"
  }

  # The Critical Metric: "Did the AI get it right?"
  # We expect this % to be HIGH for Critical Risk and LOW for Low Risk
  measure: actual_failure_rate {
    type: number
    sql: SUM(${actual_late_count}) / NULLIF(SUM(${total_volume}), 0) ;;
    value_format: "0.0\%"
    label: "Actual Failure Rate"
    description: "Percentage of shipments in this risk bucket that actually arrived late"
  }
}