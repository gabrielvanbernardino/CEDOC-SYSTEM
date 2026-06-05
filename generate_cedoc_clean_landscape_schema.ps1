Add-Type -AssemblyName System.Drawing

$outPng = Join-Path $PSScriptRoot "cedoc_clean_data_schema_landscape_hd.png"
$outJpg = Join-Path $PSScriptRoot "cedoc_clean_data_schema_landscape_hd.jpg"

$canvasW = 3300
$canvasH = 1850
$bmp = New-Object System.Drawing.Bitmap($canvasW, $canvasH)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$g.Clear([System.Drawing.Color]::White)

$black = [System.Drawing.Color]::Black
$borderPen = New-Object System.Drawing.Pen($black, 3)
$rowPen = New-Object System.Drawing.Pen($black, 1)
$relationPen = New-Object System.Drawing.Pen($black, 3)
$relationPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$relationPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

$brush = New-Object System.Drawing.SolidBrush($black)
$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$tableFont = New-Object System.Drawing.Font("Arial", 22, [System.Drawing.FontStyle]::Bold)
$columnFont = New-Object System.Drawing.Font("Arial", 17, [System.Drawing.FontStyle]::Regular)
$keyFont = New-Object System.Drawing.Font("Arial", 17, [System.Drawing.FontStyle]::Bold)

$script:headerH = 56
$script:rowH = 34
$script:dotR = 7

$tables = [ordered]@{
  users = @(
    "PK user_id BIGINT",
    "UQ cedoc_id VARCHAR",
    "username VARCHAR",
    "password VARCHAR",
    "cedoc_name VARCHAR",
    "email_address VARCHAR",
    "contacts VARCHAR",
    "role VARCHAR",
    "account_type VARCHAR",
    "responder_type VARCHAR",
    "vehicle_type VARCHAR",
    "status VARCHAR"
  )
  user_time_render = @(
    "PK/FK cedoc_id VARCHAR",
    "full_name VARCHAR",
    "activity_date DATE",
    "login_at TIMESTAMP",
    "logout_at TIMESTAMP",
    "render_seconds BIGINT",
    "case_report_created INTEGER",
    "active_state VARCHAR"
  )
  cedoc_id_year_sequence = @(
    "PK registration_year INTEGER",
    "last_sequence INTEGER",
    "updated_at TIMESTAMP"
  )
  system_setting = @(
    "PK setting_key VARCHAR",
    "system_name VARCHAR",
    "organization_name VARCHAR",
    "contact_number VARCHAR",
    "email_address VARCHAR",
    "time_zone VARCHAR",
    "theme_mode VARCHAR",
    "sidebar_style VARCHAR",
    "log_style VARCHAR",
    "updated_by VARCHAR"
  )
  accident_cases = @(
    "PK case_id VARCHAR",
    "case_number VARCHAR",
    "case_date VARCHAR",
    "time_label VARCHAR",
    "case_type VARCHAR",
    "name_of_caller VARCHAR",
    "contact_number VARCHAR",
    "location VARCHAR",
    "barangay VARCHAR",
    "status VARCHAR",
    "FK created_by_cedoc_id VARCHAR",
    "created_at TIMESTAMP"
  )
  medical_reports = @(
    "PK report_id VARCHAR",
    "FK case_id VARCHAR",
    "case_number VARCHAR",
    "patient_name VARCHAR",
    "age INTEGER",
    "gender VARCHAR",
    "location VARCHAR",
    "case_type VARCHAR",
    "status VARCHAR",
    "draft BOOLEAN",
    "FK created_by_cedoc_id VARCHAR"
  )
  fire_reports = @(
    "PK report_id VARCHAR",
    "FK case_id VARCHAR",
    "location VARCHAR",
    "date_started DATE",
    "time_started VARCHAR",
    "cause_of_fire VARCHAR",
    "number_of_deaths INTEGER",
    "number_of_injuries INTEGER",
    "status VARCHAR",
    "draft BOOLEAN",
    "FK created_by_cedoc_id VARCHAR"
  )
  traffic_reports = @(
    "PK report_id VARCHAR",
    "FK case_id VARCHAR",
    "responder_name VARCHAR",
    "accident_date VARCHAR",
    "address VARCHAR",
    "barangay VARCHAR",
    "vehicles_involved INTEGER",
    "status VARCHAR",
    "draft BOOLEAN",
    "FK created_by_cedoc_id VARCHAR"
  )
  medical_reports_archive = @(
    "PK/FK report_id VARCHAR",
    "FK case_id VARCHAR",
    "case_number VARCHAR",
    "patient_name VARCHAR",
    "case_type VARCHAR",
    "status VARCHAR",
    "FK created_by_cedoc_id VARCHAR",
    "FK archived_by_cedoc_id VARCHAR",
    "archived_at TIMESTAMP",
    "archive_reason VARCHAR"
  )
  accident_cases_archive = @(
    "PK/FK case_id VARCHAR",
    "case_number VARCHAR",
    "case_type VARCHAR",
    "location VARCHAR",
    "barangay VARCHAR",
    "status VARCHAR",
    "FK created_by_cedoc_id VARCHAR",
    "FK archived_by_cedoc_id VARCHAR",
    "archived_at TIMESTAMP",
    "archive_reason VARCHAR"
  )
  fire_reports_archive = @(
    "PK/FK report_id VARCHAR",
    "FK case_id VARCHAR",
    "location VARCHAR",
    "date_started DATE",
    "cause_of_fire VARCHAR",
    "status VARCHAR",
    "FK created_by_cedoc_id VARCHAR",
    "FK archived_by_cedoc_id VARCHAR",
    "archived_at TIMESTAMP",
    "archive_reason VARCHAR"
  )
  traffic_reports_archive = @(
    "PK/FK report_id VARCHAR",
    "FK case_id VARCHAR",
    "responder_name VARCHAR",
    "accident_date VARCHAR",
    "address VARCHAR",
    "barangay VARCHAR",
    "status VARCHAR",
    "FK created_by_cedoc_id VARCHAR",
    "FK archived_by_cedoc_id VARCHAR",
    "archived_at TIMESTAMP",
    "archive_reason VARCHAR"
  )
}

$layout = @{
  users = @{ X = 70; Y = 60; W = 650 }
  user_time_render = @{ X = 70; Y = 590; W = 650 }
  cedoc_id_year_sequence = @{ X = 70; Y = 960; W = 650 }
  system_setting = @{ X = 70; Y = 1230; W = 650 }

  accident_cases = @{ X = 780; Y = 500; W = 700 }

  medical_reports = @{ X = 1620; Y = 60; W = 700 }
  fire_reports = @{ X = 1620; Y = 720; W = 700 }
  traffic_reports = @{ X = 1620; Y = 1380; W = 700 }

  medical_reports_archive = @{ X = 2440; Y = 60; W = 760 }
  accident_cases_archive = @{ X = 2440; Y = 500; W = 760 }
  fire_reports_archive = @{ X = 2440; Y = 940; W = 760 }
  traffic_reports_archive = @{ X = 2440; Y = 1380; W = 760 }
}

function Table-H($name) { return $script:headerH + ($tables[$name].Count * $script:rowH) }
function Left($name) { return $layout[$name].X }
function Right($name) { return $layout[$name].X + $layout[$name].W }
function Top($name) { return $layout[$name].Y }
function Bottom($name) { return $layout[$name].Y + (Table-H $name) }

function RowY($name, $fieldName) {
  for ($i = 0; $i -lt $tables[$name].Count; $i++) {
    $pattern = "(^|\s)" + [regex]::Escape($fieldName) + "(\s|$)"
    if ($tables[$name][$i] -match $pattern) {
      return $layout[$name].Y + $script:headerH + ($i * $script:rowH) + [int]($script:rowH / 2)
    }
  }
  return $layout[$name].Y + [int]((Table-H $name) / 2)
}

function Port($table, $field, $side) {
  $x = if ($side -eq "L") { Left $table } else { Right $table }
  return @($x, (RowY $table $field))
}

function Draw-Polyline($points) {
  for ($i = 0; $i -lt $points.Count - 1; $i++) {
    $g.DrawLine($relationPen, $points[$i][0], $points[$i][1], $points[$i + 1][0], $points[$i + 1][1])
  }
}

function Draw-Table($name) {
  $x = $layout[$name].X
  $y = $layout[$name].Y
  $w = $layout[$name].W
  $h = Table-H $name

  $g.FillRectangle($whiteBrush, $x, $y, $w, $h)
  $g.DrawRectangle($borderPen, $x, $y, $w, $h)
  $g.DrawLine($borderPen, $x, $y + $script:headerH, $x + $w, $y + $script:headerH)
  $g.DrawString($name, $tableFont, $brush, $x + 16, $y + 13)

  $cy = $y + $script:headerH
  foreach ($column in $tables[$name]) {
    $font = if ($column.StartsWith("PK") -or $column.StartsWith("UQ") -or $column.StartsWith("FK")) { $keyFont } else { $columnFont }
    $g.DrawLine($rowPen, $x, $cy + $script:rowH, $x + $w, $cy + $script:rowH)
    $g.DrawString($column, $font, $brush, $x + 16, $cy + 7)
    $cy += $script:rowH
  }
}

function Draw-Dot($point) {
  $d = $script:dotR * 2
  $g.FillEllipse($brush, $point[0] - $script:dotR, $point[1] - $script:dotR, $d, $d)
}

function Make-DirectRelation($fromTable, $fromField, $fromSide, $toTable, $toField, $toSide, $label) {
  $from = Port $fromTable $fromField $fromSide
  $to = Port $toTable $toField $toSide
  $midX = [int](($from[0] + $to[0]) / 2)
  return @{
    Points = @($from, @($midX, $from[1]), @($midX, $to[1]), $to)
    From = $from
    To = $to
  }
}

function Make-BusRelation($fromTable, $fromField, $fromSide, $busX, $toTable, $toField, $toSide, $label) {
  $from = Port $fromTable $fromField $fromSide
  $to = Port $toTable $toField $toSide
  return @{
    Points = @($from, @($busX, $from[1]), @($busX, $to[1]), $to)
    From = $from
    To = $to
  }
}

$relations = @()

# Main user relationship.
$relations += Make-BusRelation "users" "cedoc_id" "R" 750 "user_time_render" "cedoc_id" "R" ""
$relations += Make-BusRelation "users" "cedoc_id" "R" 750 "accident_cases" "created_by_cedoc_id" "L" ""

# Case-to-report rows.
$relations += Make-DirectRelation "accident_cases" "case_id" "R" "medical_reports" "case_id" "L" "case_id"
$relations += Make-DirectRelation "accident_cases" "case_id" "R" "fire_reports" "case_id" "L" "case_id"
$relations += Make-DirectRelation "accident_cases" "case_id" "R" "traffic_reports" "case_id" "L" "case_id"
$relations += Make-DirectRelation "accident_cases" "case_id" "R" "accident_cases_archive" "case_id" "L" "case_id"

# Active records-to-archive rows.
$relations += Make-DirectRelation "medical_reports" "report_id" "R" "medical_reports_archive" "report_id" "L" "report_id"
$relations += Make-DirectRelation "fire_reports" "report_id" "R" "fire_reports_archive" "report_id" "L" "report_id"
$relations += Make-DirectRelation "traffic_reports" "report_id" "R" "traffic_reports_archive" "report_id" "L" "report_id"

foreach ($relation in $relations) {
  Draw-Polyline $relation.Points
}

foreach ($name in $tables.Keys) {
  Draw-Table $name
}

foreach ($relation in $relations) {
}

$bmp.Save($outPng, [System.Drawing.Imaging.ImageFormat]::Png)
$jpgEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 96L)
$bmp.Save($outJpg, $jpgEncoder, $encoderParams)

$g.Dispose()
$bmp.Dispose()

Write-Host "Generated:"
Write-Host $outPng
Write-Host $outJpg
