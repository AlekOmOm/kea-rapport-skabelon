# Makefile 

.PHONY: svg
svg:
	mmdc -i .\assets\rapport-struktur.mmd -o .\assets\rapport-struktur.svg -c .\assets\mermaid-config.json

svg-dark:
	mmdc -i .\assets\rapport-struktur.dark.mmd -o .\assets\rapport-struktur.dark.svg -c .\assets\mermaid-config.dark.json


