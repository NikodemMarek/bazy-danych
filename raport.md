# Dokumentacja Projektu Bazy Danych: "System Giełdowy"

## 1. Wprowadzenie i Cele Projektu

Celem projektu było zaprojektowanie i implementacja relacyjnej bazy danych dla uproszczonego systemu transakcyjnego, symulującego działanie giełdy papierów wartościowych.

Główne cele projektu obejmowały:
*   Praktyczne zastosowanie wiedzy z zakresu modelowania i projektowania relacyjnych baz danych.
*   Implementację integralności danych za pomocą kluczy, ograniczeń (`constraints`) i typów wyliczeniowych.
*   Wykorzystanie zaawansowanych mechanizmów bazodanowych, takich jak widoki (`views`), funkcje (`functions`) i wyzwalacze (`triggers`), do automatyzacji procesów.
*   Zaprojektowanie i wdrożenie modelu uprawnień opartego na rolach w celu zapewnienia bezpieczeństwa i kontroli dostępu do danych.

System został zaimplementowany w oparciu o silnik bazy danych **PostgreSQL**.

## 2. Architektura Bazy Danych

Schemat bazy danych został zaprojektowany w celu spójnego i logicznego przechowywania informacji o użytkownikach, ich zasobach finansowych, instrumentach giełdowych oraz operacjach handlowych.

### Główne Tabele:

*   `user`: Przechowuje dane uwierzytelniające i osobowe użytkowników systemu. Każdy użytkownik jest jednoznacznie identyfikowany przez adres e-mail, a hasła są haszowane przy użyciu rozszerzenia `pgcrypto`.
*   `wallet`: Reprezentuje portfel finansowy użytkownika, przechowujący informacje o stanie środków pieniężnych w określonej walucie.
*   `instrument_type`: Tabela słownikowa definiująca kategorie instrumentów finansowych (np. akcja, ETF, kryptowaluta).
*   `instrument`: Katalog instrumentów dostępnych w obrocie, zawierający ich unikalny ticker, kraj pochodzenia oraz bieżące ceny kupna (ask) i sprzedaży (bid).
*   `portfolio`: Tabela asocjacyjna, która mapuje portfele użytkowników na posiadane przez nich instrumenty i ich ilość.
*   `order`: Rejestruje zlecenia kupna lub sprzedaży składane przez użytkowników. Zawiera informacje o ilości, cenie limitu oraz statusie zlecenia (`open`, `filled`, `cancelled`).
*   `transaction`: Szczegółowy zapis zrealizowanych transakcji, dokumentujący cenę, ilość, naliczoną prowizję oraz dokładny czas wykonania operacji.
*   `price_history`: Archiwum historycznych danych cenowych (OHLCV) dla instrumentów w różnych interwałach czasowych, kluczowe dla analiz rynkowych.

### Relacje i Integralność:

Spójność danych jest zapewniona przez system kluczy głównych i obcych, które poprawnie odwzorowują zależności między tabelami (np. `wallet` jest powiązany z `user`, a `transaction` z `order`).

## 3. Widoki Aplikacyjne

W celu uproszczenia zapytań i ułatwienia dostępu do zagregowanych danych, zdefiniowano następujące widoki:

*   `v_user_portfolio_valuation`: Dynamicznie oblicza i prezentuje bieżącą wartość rynkową każdego składnika portfela użytkownika.
*   `v_transaction_history`: Zapewnia ustrukturyzowany i chronologiczny przegląd wszystkich historycznych transakcji.
*   `v_active_orders`: Udostępnia listę wszystkich zleceń, które aktualnie oczekują na realizację na rynku.
*   `v_price_history`: Agreguje i prezentuje historyczne dane cenowe dla poszczególnych instrumentów, ułatwiając analizę trendów.

## 4. Automatyzacja Procesów Biznesowych

Dwa kluczowe procesy biznesowe zostały zautomatyzowane przy użyciu funkcji i wyzwalaczy (triggers):

### a) Mechanizm Wykonywania Zleceń

*   **Cel:** Automatyczne finalizowanie transakcji, gdy warunki rynkowe pozwalają na dopasowanie zleceń kupna i sprzedaży.
*   **Implementacja:** Wyzwalacz `trg_process_order_matching_after_insert`, uruchamiany po dodaniu nowego rekordu do tabeli `order`, inicjuje funkcję `process_order_matching()`. Funkcja ta wyszukuje w systemie przeciwstawne zlecenie o zgodnych kryteriach cenowych. W przypadku znalezienia dopasowania, funkcja `execute_trade()` finalizuje transakcję, aktualizuje statusy zleceń i generuje odpowiednie rekordy w tabeli `transaction`. Mechanizm obsługuje również zlecenia częściowo zrealizowane, tworząc nowe zlecenie na pozostałą do wykonania ilość.

### b) Aktualizacja Salda Portfela

*   **Cel:** Zapewnienie, że stan środków pieniężnych w portfelu użytkownika jest automatycznie korygowany po każdej transakcji.
*   **Implementacja:** Wyzwalacz `trg_update_wallet_balance_on_transaction_insert`, aktywowany po każdej nowej transakcji, wywołuje funkcję `update_wallet_balance()`. Funkcja ta odpowiednio obciąża (przy kupnie) lub zasila (przy sprzedaży) saldo portfela, uwzględniając wartość transakcji oraz naliczoną prowizję.

## 5. Zapewnienie Jakości i Spójności Danych

Integralność danych jest kluczowym elementem projektu, realizowanym poprzez następujące ograniczenia (`constraints`):

*   **Ograniczenia `UNIQUE`:** Wymuszają unikalność kluczowych danych biznesowych, takich jak adresy e-mail użytkowników (`user.email`) czy kombinacja `(ticker, country, itid)` dla instrumentów.
*   **Ograniczenia `CHECK`:** Weryfikują poprawność danych na poziomie logiki biznesowej. Przykładowo, `wallet.balance` nie może być ujemny, `order.quantity` musi być wartością dodatnią, a `transaction.price` nie może być zerowy. Zapewniają one, że w bazie danych nie pojawią się rekordy niespełniające podstawowych założeń systemu.

## 6. Model Bezpieczeństwa i Zarządzanie Dostępem

Zaimplementowano trójwarstwowy model bezpieczeństwa oparty na rolach, aby precyzyjnie kontrolować dostęp do danych:

*   `group_admin`: Rola administracyjna z pełnymi uprawnieniami do zarządzania schematem i danymi.
*   `group_application`: Rola przeznaczona dla warstwy aplikacyjnej, posiadająca uprawnienia do wykonywania operacji CRUD (Create, Read, Update, Delete) w zakresie niezbędnym do obsługi logiki biznesowej.
*   `group_analyst`: Rola z uprawnieniami wyłącznie do odczytu (`read-only`), przeznaczona do celów analitycznych i raportowych, bez możliwości modyfikacji danych.

Użytkownicy są tworzeni i przypisywani do odpowiednich ról za pomocą skryptów, co ułatwia zarządzanie i automatyzuje proces konfiguracji środowiska.
