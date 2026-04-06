/// The architectural layer a class belongs to according to Clean Architecture.
enum WardenLayer {
  /// Responsible for fetching, storing, and mapping external data.
  data,

  /// Contains the core business rules, entities, and use cases.
  domain,

  /// Handles UI, state management, and user interaction.
  presentation,

  /// Provides low-level services like logging, network clients, device APIs.
  infrastructure,
}
