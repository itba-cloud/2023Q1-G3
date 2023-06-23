data "archive_file" "this" {
  type        = "zip"
  source_file = local.file_name
  output_path = local.zip_file_name
}