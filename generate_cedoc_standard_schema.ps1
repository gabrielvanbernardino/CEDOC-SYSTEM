Add-Type -AssemblyName System.Core

$sqlPath = Join-Path $PSScriptRoot "official database\official_cedoc_final.sql"
$outPath = Join-Path $PSScriptRoot "cedoc_standard_relational_schema.sql"

$raw = [System.IO.File]::ReadAllText($sqlPath)
$sql = [regex]::Replace($raw, "[^\u0009\u000A\u000D\u0020-\u007E]", "")

$tableOrder = @(
  "users",
  "cedoc_id_year_sequence",
  "system_setting",
  "accident_cases",
  "user_time_render",
  "medical_reports",
  "fire_reports",
  "traffic_reports",
  "accident_cases_archive",
  "medical_reports_archive",
  "fire_reports_archive",
  "traffic_reports_archive"
)

$primaryKeys = @{
  users = "user_id"
  cedoc_id_year_sequence = "registration_year"
  system_setting = "setting_key"
  accident_cases = "case_id"
  user_time_render = "cedoc_id"
  medical_reports = "report_id"
  fire_reports = "report_id"
  traffic_reports = "report_id"
  accident_cases_archive = "case_id"
  medical_reports_archive = "report_id"
  fire_reports_archive = "report_id"
  traffic_reports_archive = "report_id"
}

$uniqueKeys = @{
  users = @("cedoc_id")
}

$foreignKeys = @{
  accident_cases = @(
    @{ Column = "created_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" }
  )
  user_time_render = @(
    @{ Column = "cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "CASCADE" }
  )
  medical_reports = @(
    @{ Column = "case_id"; RefTable = "accident_cases"; RefColumn = "case_id"; OnUpdate = "CASCADE"; OnDelete = "SET NULL" },
    @{ Column = "created_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" }
  )
  fire_reports = @(
    @{ Column = "case_id"; RefTable = "accident_cases"; RefColumn = "case_id"; OnUpdate = "CASCADE"; OnDelete = "SET NULL" },
    @{ Column = "created_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" }
  )
  traffic_reports = @(
    @{ Column = "case_id"; RefTable = "accident_cases"; RefColumn = "case_id"; OnUpdate = "CASCADE"; OnDelete = "SET NULL" },
    @{ Column = "created_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" }
  )
  accident_cases_archive = @(
    @{ Column = "case_id"; RefTable = "accident_cases"; RefColumn = "case_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" },
    @{ Column = "created_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" },
    @{ Column = "archived_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" }
  )
  medical_reports_archive = @(
    @{ Column = "report_id"; RefTable = "medical_reports"; RefColumn = "report_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" },
    @{ Column = "case_id"; RefTable = "accident_cases"; RefColumn = "case_id"; OnUpdate = "CASCADE"; OnDelete = "SET NULL" },
    @{ Column = "created_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" },
    @{ Column = "archived_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" }
  )
  fire_reports_archive = @(
    @{ Column = "report_id"; RefTable = "fire_reports"; RefColumn = "report_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" },
    @{ Column = "case_id"; RefTable = "accident_cases"; RefColumn = "case_id"; OnUpdate = "CASCADE"; OnDelete = "SET NULL" },
    @{ Column = "created_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" },
    @{ Column = "archived_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" }
  )
  traffic_reports_archive = @(
    @{ Column = "report_id"; RefTable = "traffic_reports"; RefColumn = "report_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" },
    @{ Column = "case_id"; RefTable = "accident_cases"; RefColumn = "case_id"; OnUpdate = "CASCADE"; OnDelete = "SET NULL" },
    @{ Column = "created_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" },
    @{ Column = "archived_by_cedoc_id"; RefTable = "users"; RefColumn = "cedoc_id"; OnUpdate = "CASCADE"; OnDelete = "RESTRICT" }
  )
}

function Convert-Type($tableName, $columnName, $rawType) {
  if ($columnName -eq "cedoc_id" -or $columnName.EndsWith("_cedoc_id")) {
    return "VARCHAR"
  }

  $type = $rawType.Trim().ToLowerInvariant()
  switch -Regex ($type) {
    "^character varying\((\d+)\)$" { return "VARCHAR" }
    "^varchar\((\d+)\)$" { return "VARCHAR" }
    "^timestamp with time zone$" { return "TIMESTAMP" }
    "^timestamp without time zone$" { return "TIMESTAMP" }
    "^text$" { return "VARCHAR" }
    "^bigint$" { return "BIGINT" }
    "^integer$" { return "INTEGER" }
    "^double precision$" { return "DOUBLE PRECISION" }
    "^boolean$" { return "BOOLEAN" }
    "^date$" { return "DATE" }
    default { return $rawType.ToUpperInvariant() }
  }
}

function Get-Columns($tableName) {
  $pattern = "CREATE TABLE public\.$tableName\s*\((.*?)\);"
  $match = [regex]::Match($sql, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
  if (-not $match.Success) {
    throw "Table not found in official database SQL: $tableName"
  }

  $columns = New-Object System.Collections.Generic.List[object]
  foreach ($line in ($match.Groups[1].Value -split "`n")) {
    $clean = $line.Trim().TrimEnd(",")
    if ([string]::IsNullOrWhiteSpace($clean)) { continue }
    if ($clean -match "^CONSTRAINT\s+") { continue }
    if ($clean -match "^([a-zA-Z_][a-zA-Z0-9_]*)\s+(.+)$") {
      $name = $matches[1]
      $typeAndRules = $matches[2]
      $notNull = $typeAndRules -match "\s+NOT NULL\s*$"
      $typeOnly = $typeAndRules -replace "\s+NOT NULL\s*$", ""
      $typeOnly = $typeOnly -replace "\s+DEFAULT\s+.*$", ""
      $typeOnly = $typeOnly.Trim()
      $standardType = Convert-Type $tableName $name $typeOnly
      $columns.Add([pscustomobject]@{
        Name = $name
        Type = $standardType
        NotNull = $notNull
      })
    }
  }
  return $columns
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("-- CEDOC Accident Recording and Reporting System")
$lines.Add("-- Standard platform-agnostic relational schema")
$lines.Add("-- Core business tables only. Supabase auth/storage/realtime/RLS/RPC objects are intentionally excluded.")
$lines.Add("")

foreach ($table in $tableOrder) {
  $columns = @(Get-Columns $table)
  $defs = New-Object System.Collections.Generic.List[string]

  foreach ($column in $columns) {
    $notNull = if ($column.NotNull) { " NOT NULL" } else { "" }
    $defs.Add("    $($column.Name) $($column.Type)$notNull")
  }

  $defs.Add("    CONSTRAINT pk_$table PRIMARY KEY ($($primaryKeys[$table]))")

  if ($uniqueKeys.ContainsKey($table)) {
    foreach ($column in $uniqueKeys[$table]) {
      $defs.Add("    CONSTRAINT uq_${table}_${column} UNIQUE ($column)")
    }
  }

  if ($foreignKeys.ContainsKey($table)) {
    foreach ($fk in $foreignKeys[$table]) {
      $name = "fk_${table}_$($fk.Column)"
      $defs.Add("    CONSTRAINT $name FOREIGN KEY ($($fk.Column)) REFERENCES $($fk.RefTable)($($fk.RefColumn)) ON UPDATE $($fk.OnUpdate) ON DELETE $($fk.OnDelete)")
    }
  }

  $lines.Add("CREATE TABLE $table (")
  for ($i = 0; $i -lt $defs.Count; $i++) {
    $suffix = if ($i -lt $defs.Count - 1) { "," } else { "" }
    $lines.Add("$($defs[$i])$suffix")
  }
  $lines.Add(");")
  $lines.Add("")
}

[System.IO.File]::WriteAllLines($outPath, $lines)
Write-Host "Generated:"
Write-Host $outPath
