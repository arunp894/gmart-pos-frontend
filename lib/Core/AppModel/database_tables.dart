class DatabaseTables {
  static const List<String> allTables = [
    productTable,
    categoriesTable,
    variationsTable,
  ];
  static const String productTable = '''
          CREATE TABLE IF NOT EXISTS products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER NOT NULL,
          name TEXT NOT NULL,
          type TEXT NOT NULL,
          category_id INTEGER NOT NULL,
          location_id INTEGER NOT NULL,
          business_id INTEGER NOT NULL,
          variation_id INTEGER UNIQUE NOT NULL,
          unit TEXT NOT NULL,
          barcode TEXT NOT NULL,
          default_selling_price TEXT NOT NULL,
          selling_price_inc_tax TEXT NOT NULL,
          pos_edit INTEGER DEFAULT 0,
          is_delete INTEGER DEFAULT 0,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
  ''';
  static const String categoriesTable = '''
        CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER UNIQUE NOT NULL,
        category TEXT UNIQUE,
        code TEXT,
        parent_id INTEGER NULL,
        business_id INTEGER NOT NULL,
        age_limit TEXT NULL,
        age_description TEXT NULL,
        from_time TEXT NULL,
        to_time TEXT NULL,
        time_description TEXT NULL,
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
  ''';
  static const String subCategoriesTable = '''
        CREATE TABLE IF NOT EXISTS sub_categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        sub_category TEXT,
        code TEXT,
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
      );
  ''';
  static const String variationsTable = '''
        CREATE TABLE IF NOT EXISTS variations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        variation_double_id INTEGER UNIQUE NOT NULL,
        name TEXT,
        product_id INTEGER NOT NULL,
        barcode TEXT,
        default_selling_price TEXT NOT NULL,
        selling_price_inc_tax TEXT NOT NULL,
        unit TEXT NOT NULL,
        variation_id INTEGER DEFAULT NULL,
        location_id INTEGER DEFAULT NULL,
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
  ''';

  static const String brandsTable = '''
        CREATE TABLE IF NOT EXISTS brands (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        brand TEXT,
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
  ''';
  static const String applicableTaxTable = '''
        CREATE TABLE IF NOT EXISTS applicable_tax (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tax_name TEXT,
        tax_value TEXT,
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
  ''';
  static const String productTypesTable = '''
        CREATE TABLE IF NOT EXISTS product_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_type TEXT UNIQUE,
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
  ''';
  static const String unitsTable = '''
        CREATE TABLE IF NOT EXISTS units (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        unit TEXT UNIQUE,
        unit_value TEXT,
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
  ''';
  static const String barcodesTable = '''
        CREATE TABLE IF NOT EXISTS barcodes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT,
        barcode_value TEXT, 
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
  ''';
  static const String sellingTaxTable = '''
        CREATE TABLE IF NOT EXISTS selling_tax (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        selling_tax_name TEXT UNIQUE,
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
  ''';
  static const String productStocksTable = '''
        CREATE TABLE IF NOT EXISTS product_stocks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        available_quantity INTEGER,  -- this can be any number up to 9 quintillion+
        alert_quantity INTEGER,
        tag TEXT,
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
      );                                                  
  ''';
  static const String ordersTable = '''
        CREATE TABLE IF NOT EXISTS orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ordered_products TEXT, -- JSON encoded string
        total_amount TEXT,
        discount_type TEXT,
        discount_amount TEXT,
        bill_no TEXT NOT NULL UNIQUE,
        payment_type TEXT, -- JSON encoded string
        status TEXT,
        is_delete INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );                                                
  ''';
  static const String alterTable = '''
        ALTER TABLE orders ADD COLUMN return_by TEXT NULL;                                                
  ''';
}
