# Clean DB in dependency order
puts "Cleaning database..."
Review.destroy_all
OrderItem.destroy_all
Order.destroy_all
CartItem.destroy_all
Cart.destroy_all
Product.destroy_all
Category.destroy_all
Brand.destroy_all

# ─────────────────────────────────────────────
# BRANDS
# ─────────────────────────────────────────────
puts "Seeding brands..."

apple   = Brand.create!(name: "Apple",   status: :active)
samsung = Brand.create!(name: "Samsung", status: :active)
nike    = Brand.create!(name: "Nike",    status: :active)
adidas  = Brand.create!(name: "Adidas",  status: :active)
ikea    = Brand.create!(name: "IKEA",    status: :active)
dyson   = Brand.create!(name: "Dyson",   status: :active)
sony    = Brand.create!(name: "Sony",    status: :active)
levi    = Brand.create!(name: "Levi's",  status: :active)

# ─────────────────────────────────────────────
# CATEGORIES  (max 3 levels; products go in leaf nodes)
# ─────────────────────────────────────────────
puts "Seeding categories..."

# Root
electronics   = Category.create!(name: "Electronics",   status: :active)
clothing      = Category.create!(name: "Clothing",       status: :active)
home_living   = Category.create!(name: "Home & Living",  status: :active)
sports        = Category.create!(name: "Sports",         status: :active)

# Level 2
phones_tablets = Category.create!(name: "Phones & Tablets", parent: electronics, status: :active)
computers      = Category.create!(name: "Computers",        parent: electronics, status: :active)
audio          = Category.create!(name: "Audio",            parent: electronics, status: :active)

mens_clothing  = Category.create!(name: "Men's Clothing",   parent: clothing, status: :active)
womens_clothing= Category.create!(name: "Women's Clothing", parent: clothing, status: :active)

furniture      = Category.create!(name: "Furniture",        parent: home_living, status: :active)
kitchen        = Category.create!(name: "Kitchen",          parent: home_living, status: :active)

running        = Category.create!(name: "Running",          parent: sports, status: :active)
gym            = Category.create!(name: "Gym & Training",   parent: sports, status: :active)

# Level 3 (leaf – products go here)
smartphones    = Category.create!(name: "Smartphones", parent: phones_tablets, status: :active)
tablets        = Category.create!(name: "Tablets",     parent: phones_tablets, status: :active)
laptops        = Category.create!(name: "Laptops",     parent: computers,      status: :active)
headphones     = Category.create!(name: "Headphones",  parent: audio,          status: :active)
speakers       = Category.create!(name: "Speakers",    parent: audio,          status: :active)

mens_tshirts   = Category.create!(name: "T-Shirts",    parent: mens_clothing,   status: :active)
mens_pants     = Category.create!(name: "Pants",       parent: mens_clothing,   status: :active)
womens_dresses = Category.create!(name: "Dresses",     parent: womens_clothing, status: :active)

chairs         = Category.create!(name: "Chairs",      parent: furniture, status: :active)
cookware       = Category.create!(name: "Cookware",    parent: kitchen,   status: :active)

running_shoes  = Category.create!(name: "Running Shoes", parent: running, status: :active)
gym_wear       = Category.create!(name: "Gym Wear",      parent: gym,     status: :active)

# ─────────────────────────────────────────────
# PRODUCTS
# ─────────────────────────────────────────────
puts "Seeding products..."

products = [
  # ── Smartphones ──
  {
    name: "iPhone 15 Pro",
    sku: "APL-IP15PRO",
    short_description: "Apple's most powerful iPhone with titanium design.",
    description: "The iPhone 15 Pro features a grade-5 titanium frame, A17 Pro chip, and a 48 MP main camera with next-generation portrait shots.",
    image_url: "https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=800&auto=format&fit=crop",
    category: smartphones, brand: apple,
    price: 4199.00, compare_at_price: 4599.00, cost_price: 3100.00,
    stock_quantity: 40, status: :active, is_featured: true, currency: "AED"
  },
  {
    name: "Samsung Galaxy S24 Ultra",
    sku: "SAM-S24U",
    short_description: "Samsung's flagship with built-in S Pen.",
    description: "Galaxy S24 Ultra brings a 200 MP camera, Snapdragon 8 Gen 3, and an integrated S Pen for ultimate productivity.",
    image_url: "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&auto=format&fit=crop",
    category: smartphones, brand: samsung,
    price: 3799.00, compare_at_price: 4199.00, cost_price: 2800.00,
    stock_quantity: 35, status: :active, is_featured: true, currency: "AED"
  },
  {
    name: "Samsung Galaxy A55",
    sku: "SAM-A55",
    short_description: "Mid-range powerhouse with premium design.",
    description: "The Galaxy A55 offers an Exynos 1480 chipset, 50 MP triple camera, and IP67 dust and water resistance at an accessible price.",
    image_url: "https://images.unsplash.com/photo-1567581935884-3349723552ca?w=800&auto=format&fit=crop",
    category: smartphones, brand: samsung,
    price: 1599.00, compare_at_price: 1799.00, cost_price: 1100.00,
    stock_quantity: 60, status: :active, is_featured: false, currency: "AED"
  },

  # ── Tablets ──
  {
    name: "iPad Pro 13-inch (M4)",
    sku: "APL-IPADPRO13",
    short_description: "The thinnest Apple product ever with M4 chip.",
    description: "iPad Pro with M4 delivers supercomputer-class performance in a strikingly thin design with an Ultra Retina XDR display.",
    image_url: "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=800&auto=format&fit=crop",
    category: tablets, brand: apple,
    price: 5399.00, compare_at_price: 5799.00, cost_price: 3900.00,
    stock_quantity: 20, status: :active, is_featured: true, currency: "AED"
  },
  {
    name: "Samsung Galaxy Tab S9",
    sku: "SAM-TABS9",
    short_description: "Premium Android tablet with AMOLED display.",
    description: "Galaxy Tab S9 features an 11-inch Dynamic AMOLED display, Snapdragon 8 Gen 2, and IP68 water resistance with the included S Pen.",
    image_url: "https://images.unsplash.com/photo-1561154464-82e9adf32764?w=800&auto=format&fit=crop",
    category: tablets, brand: samsung,
    price: 2999.00, compare_at_price: 3299.00, cost_price: 2100.00,
    stock_quantity: 25, status: :active, is_featured: false, currency: "AED"
  },

  # ── Laptops ──
  {
    name: "MacBook Pro 16-inch (M3 Pro)",
    sku: "APL-MBP16-M3P",
    short_description: "Pro laptop for demanding workflows.",
    description: "MacBook Pro with M3 Pro chip, 18 GB unified memory, and up to 22 hours of battery life for professionals who need maximum performance.",
    image_url: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop",
    category: laptops, brand: apple,
    price: 9999.00, compare_at_price: 10999.00, cost_price: 7500.00,
    stock_quantity: 15, status: :active, is_featured: true, currency: "AED"
  },
  {
    name: "Samsung Galaxy Book4 Pro",
    sku: "SAM-GB4PRO",
    short_description: "Ultra-thin Windows laptop with AMOLED display.",
    description: "Galaxy Book4 Pro packs an Intel Core Ultra 7, a 16-inch 3K AMOLED display, and a slim 1.55 kg chassis for professionals on the go.",
    image_url: "https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=800&auto=format&fit=crop",
    category: laptops, brand: samsung,
    price: 6499.00, compare_at_price: 6999.00, cost_price: 4800.00,
    stock_quantity: 18, status: :active, is_featured: false, currency: "AED"
  },

  # ── Headphones ──
  {
    name: "Sony WH-1000XM5",
    sku: "SNY-WH1000XM5",
    short_description: "Industry-leading noise cancellation headphones.",
    description: "WH-1000XM5 delivers exceptional noise cancellation, 30-hour battery life, and multipoint connection for seamless switching between devices.",
    image_url: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop",
    category: headphones, brand: sony,
    price: 1299.00, compare_at_price: 1499.00, cost_price: 800.00,
    stock_quantity: 50, status: :active, is_featured: true, currency: "AED"
  },
  {
    name: "AirPods Pro (2nd Gen)",
    sku: "APL-AIRPODSPRO2",
    short_description: "Apple's best-in-class true wireless earbuds.",
    description: "AirPods Pro 2 feature Active Noise Cancellation, Adaptive Transparency, Personalized Spatial Audio, and H2 chip for up to 2× more noise cancellation.",
    image_url: "https://images.unsplash.com/photo-1603351154351-5e2d0600bb77?w=800&auto=format&fit=crop",
    category: headphones, brand: apple,
    price: 799.00, compare_at_price: 899.00, cost_price: 550.00,
    stock_quantity: 80, status: :active, is_featured: true, currency: "AED"
  },

  # ── Speakers ──
  {
    name: "Sony SRS-XB43",
    sku: "SNY-SRSXB43",
    short_description: "Powerful Bluetooth speaker with Extra Bass.",
    description: "SRS-XB43 delivers punchy Extra Bass, 24-hour battery, IP67 water resistance, and party lighting for indoor and outdoor use.",
    image_url: "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=800&auto=format&fit=crop",
    category: speakers, brand: sony,
    price: 699.00, compare_at_price: 849.00, cost_price: 450.00,
    stock_quantity: 45, status: :active, is_featured: false, currency: "AED"
  },

  # ── Men's T-Shirts ──
  {
    name: "Nike Dri-FIT Training T-Shirt",
    sku: "NIK-DFTEE-M",
    short_description: "Moisture-wicking tee for intense workouts.",
    description: "Nike Dri-FIT technology moves sweat away from your skin to help keep you dry and comfortable during your hardest training sessions.",
    image_url: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&auto=format&fit=crop",
    category: mens_tshirts, brand: nike,
    price: 149.00, compare_at_price: 189.00, cost_price: 70.00,
    stock_quantity: 200, status: :active, is_featured: false, currency: "AED"
  },
  {
    name: "Adidas Essentials 3-Stripes Tee",
    sku: "ADI-ESS3S-M",
    short_description: "Classic cotton tee with iconic 3-Stripes.",
    description: "A soft cotton-jersey tee with the classic Adidas 3-Stripes branding, perfect for everyday casual wear.",
    image_url: "https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?w=800&auto=format&fit=crop",
    category: mens_tshirts, brand: adidas,
    price: 129.00, compare_at_price: 159.00, cost_price: 60.00,
    stock_quantity: 180, status: :active, is_featured: false, currency: "AED"
  },

  # ── Men's Pants ──
  {
    name: "Levi's 511 Slim Jeans",
    sku: "LEV-511-M",
    short_description: "Slim fit jeans that sit below the waist.",
    description: "511 Slim fit jeans are cut close from hip to ankle, offering a modern slim silhouette without sacrificing comfort.",
    image_url: "https://images.unsplash.com/photo-1542272454315-4c01d7abdf4a?w=800&auto=format&fit=crop",
    category: mens_pants, brand: levi,
    price: 299.00, compare_at_price: 349.00, cost_price: 160.00,
    stock_quantity: 120, status: :active, is_featured: false, currency: "AED"
  },
  {
    name: "Nike Dri-FIT Tapered Training Pants",
    sku: "NIK-DFPNT-M",
    short_description: "Tapered training pants with moisture management.",
    description: "Nike Dri-FIT tapered pants provide a clean silhouette and sweat-wicking performance for the gym or everyday wear.",
    image_url: "https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=800&auto=format&fit=crop",
    category: mens_pants, brand: nike,
    price: 249.00, compare_at_price: 299.00, cost_price: 120.00,
    stock_quantity: 90, status: :active, is_featured: false, currency: "AED"
  },

  # ── Women's Dresses ──
  {
    name: "Adidas Floral Wrap Dress",
    sku: "ADI-FWDRS-W",
    short_description: "Feminine wrap dress with a sporty edge.",
    description: "A floral-print wrap dress in soft jersey fabric, blending Adidas style with an elegant silhouette perfect for casual outings.",
    image_url: "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop",
    category: womens_dresses, brand: adidas,
    price: 279.00, compare_at_price: 329.00, cost_price: 130.00,
    stock_quantity: 75, status: :active, is_featured: true, currency: "AED"
  },

  # ── Chairs ──
  {
    name: "IKEA MARKUS Ergonomic Chair",
    sku: "IKEA-MARKUS",
    short_description: "Supportive office chair for long working hours.",
    description: "MARKUS offers lumbar support, adjustable armrests, and a breathable mesh backrest designed to keep you comfortable throughout the day.",
    image_url: "https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=800&auto=format&fit=crop",
    category: chairs, brand: ikea,
    price: 999.00, compare_at_price: 1199.00, cost_price: 600.00,
    stock_quantity: 30, status: :active, is_featured: false, currency: "AED"
  },
  {
    name: "IKEA POÄNG Armchair",
    sku: "IKEA-POANG",
    short_description: "Classic layer-glued bentwood armchair.",
    description: "The POÄNG armchair features a layer-glued bent birch frame for flexible support and a cushion in soft Glose leather.",
    image_url: "https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=800&auto=format&fit=crop",
    category: chairs, brand: ikea,
    price: 699.00, compare_at_price: nil, cost_price: 380.00,
    stock_quantity: 40, status: :active, is_featured: false, currency: "AED"
  },

  # ── Cookware ──
  {
    name: "Dyson AirWrap Complete Styler",
    sku: "DYS-AIRWRAP",
    short_description: "Style hair with controlled airflow, not extreme heat.",
    description: "Dyson AirWrap uses the Coanda effect to attract and wrap hair for curls, waves, and smoothing — without extreme heat damage.",
    image_url: "https://images.unsplash.com/photo-1522338242992-e1a54906a8da?w=800&auto=format&fit=crop",
    category: cookware, brand: dyson,
    price: 2199.00, compare_at_price: 2399.00, cost_price: 1500.00,
    stock_quantity: 25, status: :active, is_featured: true, currency: "AED"
  },

  # ── Running Shoes ──
  {
    name: "Nike Air Zoom Pegasus 41",
    sku: "NIK-PEGASUS41",
    short_description: "Versatile daily trainer for all types of runs.",
    description: "Pegasus 41 delivers a smooth, responsive ride with Zoom Air units and a wider forefoot for a more natural feel on every run.",
    image_url: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop",
    category: running_shoes, brand: nike,
    price: 549.00, compare_at_price: 649.00, cost_price: 300.00,
    stock_quantity: 150, status: :active, is_featured: true, currency: "AED"
  },
  {
    name: "Adidas Ultraboost 23",
    sku: "ADI-UB23",
    short_description: "Premium running shoe with BOOST cushioning.",
    description: "Ultraboost 23 features Continental rubber outsole, BOOST midsole, and a Primeknit+ upper that wraps your foot for a perfect fit.",
    image_url: "https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&auto=format&fit=crop",
    category: running_shoes, brand: adidas,
    price: 599.00, compare_at_price: 699.00, cost_price: 330.00,
    stock_quantity: 130, status: :active, is_featured: true, currency: "AED"
  },

  # ── Gym Wear ──
  {
    name: "Nike Pro Dri-FIT Tight (Men)",
    sku: "NIK-PROTIGHT-M",
    short_description: "Compression tight for training support.",
    description: "Nike Pro tights offer targeted compression and Dri-FIT technology, helping reduce muscle fatigue during intense training sessions.",
    image_url: "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800&auto=format&fit=crop",
    category: gym_wear, brand: nike,
    price: 199.00, compare_at_price: 249.00, cost_price: 90.00,
    stock_quantity: 110, status: :active, is_featured: false, currency: "AED"
  },
  {
    name: "Adidas Techfit Compression Tee",
    sku: "ADI-TECHFIT-M",
    short_description: "Compression tee for peak athletic performance.",
    description: "Techfit compression fabric supports your muscles and moves with your body, keeping you focused during every rep.",
    image_url: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&auto=format&fit=crop",
    category: gym_wear, brand: adidas,
    price: 179.00, compare_at_price: 219.00, cost_price: 80.00,
    stock_quantity: 95, status: :active, is_featured: false, currency: "AED"
  },
]

products.each do |attrs|
  Product.create!(attrs)
  print "."
end

puts "\n\nDone! Seeded:"
puts "  Brands:     #{Brand.count}"
puts "  Categories: #{Category.count}"
puts "  Products:   #{Product.count}"
