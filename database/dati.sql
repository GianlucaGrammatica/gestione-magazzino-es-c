USE `magazzino`;

-- 1. Inserimento Fornitori
-- Nota: Nella tua tabella 'nome' è di tipo INT(11), quindi ho usato numeri.
INSERT INTO `fornitore` (`nome`, `uid`, `indirizzo`, `identificativo_statale`) VALUES
                                                                                   (101, 'SUP-001', 'Via delle Industrie 10, Milano', 123456789),
                                                                                   (102, 'SUP-002', 'Piazza Logistica 5, Roma', 987654321),
                                                                                   (103, 'SUP-003', 'Corso Export 22, Torino', 555666777);

-- 2. Inserimento Prodotti
-- Abbiamo impostato alcune quantità già vicine alla soglia per testare il magazzino
INSERT INTO `prodotto` (`sku`, `uid_fornitore`, `nome`, `quantitaDisponibile`, `sogliaRiordino`) VALUES
                                                                                                     ('LAP-DELL-XPS', 'SUP-001', 'Dell XPS 15', 15, 5),
                                                                                                     ('MOU-LOGI-MX', 'SUP-001', 'Logitech MX Master 3', 50, 10),
                                                                                                     ('MON-SAMS-4K', 'SUP-002', 'Samsung Monitor 27 4K', 8, 10), -- Sotto soglia!
                                                                                                     ('KEY-COR-K70', 'SUP-003', 'Corsair K70 RGB', 25, 5);

-- 3. Inserimento Movimenti (Carico/Scarico)
INSERT INTO `movimento` (`sku`, `tipo`, `quantita`, `causale`) VALUES
                                                                   ('LAP-DELL-XPS', 'CARICO', 15, 'Arrivo stock iniziale'),
                                                                   ('MOU-LOGI-MX', 'CARICO', 50, 'Fornitura mensile'),
                                                                   ('MON-SAMS-4K', 'SCARICO', 2, 'Vendita cliente finale'),
                                                                   ('KEY-COR-K70', 'IN ATTESA', 5, 'Reso fornitore per difetto');

-- 4. Inserimento Avvisi Riordino (Manuale per test)
-- Il trigger che hai creato genererà questi record AUTOMATICAMENTE quando aggiorni 'prodotto'
INSERT INTO `avvisi_riordino` (`sku_prodotto`, `quantita_attuale`, `soglia_superata`, `stato`) VALUES
    ('MON-SAMS-4K', 8, 10, 'da_gestire');