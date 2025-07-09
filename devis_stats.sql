CREATE TABLE IF NOT EXISTS devis_stats (
    type INT PRIMARY KEY,
    count INT NOT NULL DEFAULT 0
);

INSERT IGNORE INTO devis_stats(type, count) VALUES (1, 0), (2, 0), (3, 0), (4, 0);
