// Generate UUID for each Mini Pupper defined in main.tf
resource "random_string" "random_mpc_minipuppers" {
  for_each = var.mpc_minipuppers == null ? {} : var.mpc_minipuppers
  length   = 8
  special  = false
  # override_special = "/@£$"
}
// Generate UUID for each Gas Sensor defined in main.tf
resource "random_string" "random_mpc_gas_sensors" {
  for_each = var.mpc_gas_sensors == null ? {} : var.mpc_gas_sensors
  length   = 8
  special  = false
  # override_special = "/@£$"
}
