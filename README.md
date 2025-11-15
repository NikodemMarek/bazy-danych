Projekt bazy danych dla giełdy papierów wartościowych, na zajęcia projektowe na studia.

---

Wszystkie pliki w folderze `init` zostaną automatycznie wykonane przy każdym uruchomieniu kontenera.
Żadne dane w bazie nie są permanentne, wszystkie zmiany wprowadzone ręcznie, na działającej bazie, znikają po zabiciu kontenera.

# Uruchamianie

```
docker compose up
```

## Podgląd bazy

`127.0.0.1:8080`

system: `PostgreSQL`
server: `db`
username: `postgres`
password: `postgres`
database: `stockmarket`
