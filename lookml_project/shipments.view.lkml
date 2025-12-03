view: shipments {
  # --- PART 1: CONNECTION ---
  # Connect this View to your MySQL Table
  sql_table_name: nexus_db.shipments ;;

  # --- PART 2: DIMENSIONS (The Columns) ---

  # The Unique ID
  dimension: tracking_number {
    primary_key: yes
    type: string
    sql: ${TABLE}.tracking_number ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}.carrier ;;
  }

  dimension: origin {
    type: string
    sql: ${TABLE}.origin ;;
  }

  dimension: destination {
    type: string
    sql: ${TABLE}.destination ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  # Dates (Looker automatically creates Date, Week, Month, Year)
  dimension_group: ship_date {
    type: time
    timeframes: [raw, date, week, month, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ship_date ;;
  }

  dimension: shipping_cost {
    type: number
    sql: ${TABLE}.shipping_cost ;;
    value_format_name: usd
  }

  # The AI Prediction (Raw Number stored in DB)
  dimension: delay_risk_score {
    type: number
    sql: ${TABLE}.delay_risk_score ;;
    value_format: "0.00\%"
  }

  # --- PART 3: MEASURES (The Business Logic) ---

  # 1. Total Volume (Count of all rows)
  measure: count {
    type: count
    drill_fields: [tracking_number, carrier, status]
    label: "Total Shipment Volume"
  }

  # 2. Total Freight Spend (Sum of cost)
  measure: total_shipping_cost {
    type: sum
    sql: ${shipping_cost} ;;
    value_format_name: usd
    label: "Total Freight Spend"
  }

  # 3. Late Shipment Count (Filters for 'Late' only)
  measure: count_late_shipments {
    type: count
    filters: [status: "Late"]
    label: "Late Shipment Volume"
  }

  # 4. AI Risk Metric (Average of the prediction column)
  measure: average_predicted_risk {
    type: average
    sql: ${delay_risk_score} ;;
    value_format: "0.00\%"
    label: "Avg. Predicted Risk Score"
  }

  # 5. On-Time In Full (OTIF) Rate Calculation
  measure: on_time_rate {
    type: number
    sql: 1 - (${count_late_shipments} / NULLIF(${count},0)) ;;
    value_format: "0.0\%"
    label: "On-Time Delivery Rate"
  }
}