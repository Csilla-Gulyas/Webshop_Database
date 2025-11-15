# Webshop_Database

## Projektleírás
Ez a projekt egy online webáruház relációs adatbázisát valósítja meg.  
A rendszer célja, hogy kezelje a felhasználókat, termékeket, rendeléseket, fizetéseket, szállítást és beszállítókat, ezzel támogatva a webáruház működését a termékek böngészésétől a megrendelés teljesítéséig.

Az adatbázis biztosítja:
- a rendelések, fizetések és kiszállítások nyomon követését,  
- a készletadatok kezelését,  
- a beszállítók és termékek kapcsolatának rögzítését,  
- valamint az adatok konzisztenciáját idegen kulcsokkal és kapcsolótáblákkal.

---

## Felhasznált technológiák
- **Adatbázis-kezelő:** MySQL  
- **Fejlesztői eszköz:** DBeaver  
- **Diagram készítés:** PlantUML  
- **Szkript nyelv:** SQL  

---

## Adatbázis szerkezete

A rendszer **10 fő táblából** áll:

| Tábla neve | Leírás |
|-------------|---------|
| `users` | Felhasználói adatok (személyes és elérhetőségi adatok) |
| `categories` | Termékkategóriák |
| `products` | Termékek adatai, ár, leírás, kategória |
| `orders` | Rendelések adatai és státuszai |
| `order_items` | Egy rendeléshez tartozó tételek |
| `payments` | Fizetési módok és tranzakciós státuszok |
| `suppliers` | Beszállítók adatai |
| `suppliers_contacts` | Beszállítók kapcsolattartói |
| `product_supplier` | Kapcsolótábla a termékek és beszállítók között (N:M kapcsolat) |
| `cart_items` | A felhasználók kosarainak tartalma |

---

## Kapcsolatok

| Kapcsolat | Típus | Leírás |
|------------|-------|--------|
| `users` → `orders` | 1:N | Egy felhasználónak több rendelése lehet |
| `orders` → `order_items` | 1:N | Egy rendelés több tételt tartalmaz |
| `products` → `order_items` | 1:N | Egy termék több rendelésben is szerepelhet |
| `products` → `categories` | N:1 | Egy termék egy kategóriába tartozik |
| `products` ↔ `suppliers` | N:M | Egy terméknek több beszállítója is lehet és fordítva |
| `suppliers` → `suppliers_contacts` | 1:1 | Egy beszállítóhoz egy kapcsolattartó tartozik |
| `users` → `cart_items` | 1:N | Egy felhasználónak több kosártétele lehet |

---

## Adatbázis diagram (PlantUML kód)

@startuml
' ==========================
' DATABASE ERD – with cardinalities
' ==========================
hide circle
skinparam linetype ortho
skinparam entity {
  BackgroundColor #fefefe
  BorderColor #999
  FontSize 12
}

' ==========================
' ENTITIES
' ==========================

entity "categories" as categories {
  *category_id : INT
  name : VARCHAR
}

entity "products" as products {
  *product_id : INT
  name : VARCHAR
  price : DECIMAL
  quantity : INT
  description : TEXT
  category_id : INT
}

entity "users" as users {
  *user_id : INT
  username : VARCHAR
  password : VARCHAR
  first_name : VARCHAR
  last_name : VARCHAR
  email : VARCHAR
  city : VARCHAR
}

entity "cart_items" as cart_items {
  *cart_item_id : INT
  quantity : INT
  product_id : INT
  user_id : INT
}

entity "suppliers" as suppliers {
  *supplier_id : INT
  name : VARCHAR
  method : VARCHAR
}

entity "suppliers_contacts" as suppliers_contacts {
  *supplier_contact_id : INT
  name : VARCHAR
  phone : VARCHAR
  email : VARCHAR
}

entity "product_supplier" as product_supplier {
  *product_id : INT
  *supplier_id : INT
}

entity "payments" as payments {
  *payment_id : INT
  status : VARCHAR
  transaction_fee : DECIMAL
  method : VARCHAR
}

entity "orders" as orders {
  *order_id : INT
  status : VARCHAR
  order_date : DATE
  shipping_time : INT
  user_id : INT
  payment_id : INT
  supplier_id : INT
}

entity "order_items" as order_items {
  *order_item_id : INT
  quantity : INT
  price : DECIMAL
  order_id : INT
  product_id : INT
}

' ==========================
' RELATIONSHIPS
' ==========================

categories ||--o{ products : "1:N"

products ||--o{ cart_items : "1:N"
users ||--o{ cart_items : "1:N"

products }o--o{ suppliers : "N:M via product_supplier"
product_supplier }o--|| products
product_supplier }o--|| suppliers

users ||--o{ orders : "1:N"
payments ||--o{ orders : "1:N"
suppliers ||--o{ orders : "1:N"

orders ||--o{ order_items : "1:N"
products ||--o{ order_items : "1:N"

suppliers ||--|| suppliers_contacts : "1:1"

@enduml

---

## Készítette

Gulyás Csilla
Adatbázisrendszerek beadandó, 2025
