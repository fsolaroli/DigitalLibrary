# 📚 Digital Library

App per iPhone che replica in forma digitale le librerie e i libri fisici presenti in casa, per ritrovare subito un libro di cui non ricordi più la posizione.

## Funzionalità

- **Gestione di librerie, scaffali e libri**: creazione, eliminazione e riordino.
- **Aggiunta di un libro** inserendo i dati a mano oppure **scansionando il codice ISBN**, con recupero automatico dei dati tramite le API di Google Books.
- **Scansione della copertina** con ritaglio automatico.
- **Preferiti** e **prestiti**: per ogni libro si può indicare a chi è stato prestato e in che data.
- **Due modalità di visualizzazione**: gerarchica (librerie → scaffali → libri) oppure tutti i libri insieme, con ricerca e filtro per i preferiti.

## Tecnologie

- Swift, SwiftUI (con una piccola parte in UIKit integrata in SwiftUI)
- Core Data e User Defaults per la persistenza
- VisionKit per la scansione della copertina
- API di Google Books (richieste GET)
- [CarBode](https://github.com/heart/CarBode-Barcode-Scanner-ForSwiftUI) per la scansione dei codici a barre
