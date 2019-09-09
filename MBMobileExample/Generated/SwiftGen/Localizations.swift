// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// decklid
  internal static let attributesDoorsDecklid = L10n.tr("Localizable", "attributes_doors_decklid")
  /// door state
  internal static let attributesDoorsDoorState = L10n.tr("Localizable", "attributes_doors_door_state")
  /// front left
  internal static let attributesDoorsFrontLeft = L10n.tr("Localizable", "attributes_doors_front_left")
  /// front right
  internal static let attributesDoorsFrontRight = L10n.tr("Localizable", "attributes_doors_front_right")
  /// lock state
  internal static let attributesDoorsLockState = L10n.tr("Localizable", "attributes_doors_lock_state")
  /// rear left
  internal static let attributesDoorsRearLeft = L10n.tr("Localizable", "attributes_doors_rear_left")
  /// rear right
  internal static let attributesDoorsRearRight = L10n.tr("Localizable", "attributes_doors_rear_right")
  /// state
  internal static let attributesDoorsState = L10n.tr("Localizable", "attributes_doors_state")
  /// Attributes Doors
  internal static let attributesDoorsTitle = L10n.tr("Localizable", "attributes_doors_title")
  /// elect.percent
  internal static let attributesTankElectricPercent = L10n.tr("Localizable", "attributes_tank_electric_percent")
  /// elect.range
  internal static let attributesTankElectricRange = L10n.tr("Localizable", "attributes_tank_electric_range")
  /// gas percent
  internal static let attributesTankGasPercent = L10n.tr("Localizable", "attributes_tank_gas_percent")
  /// gas range
  internal static let attributesTankGasRange = L10n.tr("Localizable", "attributes_tank_gas_range")
  /// liquid percent
  internal static let attributesTankLiquidPercent = L10n.tr("Localizable", "attributes_tank_liquid_percent")
  /// liquid range
  internal static let attributesTankLiquidRange = L10n.tr("Localizable", "attributes_tank_liquid_range")
  /// Attributes Tank
  internal static let attributesTankTitle = L10n.tr("Localizable", "attributes_tank_title")
  /// Command Doors
  internal static let commandDoorsTitle = L10n.tr("Localizable", "command_doors_title")
  /// errors:
  internal static let commandErrors = L10n.tr("Localizable", "command_errors")
  /// Lock
  internal static let commandLock = L10n.tr("Localizable", "command_lock")
  /// processId:
  internal static let commandProcessId = L10n.tr("Localizable", "command_process_id")
  /// state:
  internal static let commandState = L10n.tr("Localizable", "command_state")
  /// timestamp:
  internal static let commandTimestamp = L10n.tr("Localizable", "command_timestamp")
  /// Unlock
  internal static let commandUnlock = L10n.tr("Localizable", "command_unlock")
  /// Bitte verknüpfen Sie zunächst ein Fahrzeug, um diese Funktion nutzen zu können.
  internal static let sendCommandError = L10n.tr("Localizable", "send_command_error")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
