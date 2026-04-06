class WardenSuggestions {
  static String forPresentationModel() {
    return 'Did you forget to use a Mapper in the Domain Layer? Map your Data Models to Domain Entities or Presentation UI Models before passing them to the UI.';
  }

  static String forDomainData() {
    return 'Domain layer should only communicate via abstractions (Contracts/Repositories) and Entities. Move the Reponses and Models out to the Data layer and map them.';
  }
}
