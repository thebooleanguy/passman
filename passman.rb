# A program to encrypt and save your passwords securely

require 'openssl'
require 'json'


# A function to prompt and get input from the user
def prompt_user(prompt)
  print prompt
  gets.chomp
end

# A function to derive a key from my master password
def generate_key(master_password)
  OpenSSL::KDF.pbkdf2_hmac(master_password, salt: "Massive04-Brain10-Rot03", iterations: 5000, length: 32, hash: "sha256")
end

data = "SecureData01"
# key = generate_key("passwordx12334abcdd")
key = generate_key(prompt_user("Master Password: "))
iv = OpenSSL::KDF.pbkdf2_hmac("Strong05-Wolf02-Jet09", salt: "Wheel04-Fog01-Base00", iterations: 5000, length: 16, hash: "sha256")
puts key


# A custom data struct to store a vault entry
class VaultEntry
  attr_reader :name, :username, :password

  def initialize(name, username, password)
    @name = name
    @username = username
    @password = password
  end
end


vault = []


user_choice = prompt_user("Type 'E' for Encryption and 'D' for Decryption...")
# A function to encrypt my data using the key
if user_choice == "E"
  
  name = prompt_user("Entry Name: ")
  plain_username = prompt_user("Username: ")
  plain_password = prompt_user("Password: ")

  # Encryption
  cipher = OpenSSL::Cipher.new('aes-256-cfb')
  cipher.key = key
  cipher.iv = iv
  encrypted_username = cipher.update(plain_username) + cipher.final
  encrypted_password = cipher.update(plain_password) + cipher.final
  # puts encrypted
  
  vault_entry = VaultEntry.new(name, encrypted_username, encrypted_password)
  vault.push(vault_entry)
  serialized_data = Marshal.dump(vault)
  File.write('vault.marshal', serialized_data)
end

vault = Marshal.load(File.binread('vault.marshal'))
puts vault


# A function to decrypt my data using the key
if user_choice == "D"
  entry_to_decrypt_str = prompt_user("Which entry would you like to decrypt? ")
  dec_entry = vault.find { |vault_ent| vault_ent.name == entry_to_decrypt_str }

  # Decryption
  decipher = OpenSSL::Cipher.new('aes-256-cfb')
  decipher.key = key
  decipher.iv = iv
  puts "Username: " + plain_username = decipher.update(dec_entry.username) + decipher.final
  puts "Password: " + plain_password = decipher.update(dec_entry.password) + decipher.final
  # puts plain
end

# A function to load the encrypted data from disk

# A function to save the encrypted data to disk

# A function to output the decryped data to the user




### Developer Notes:
# So as this is a local implementation for my personal use within my projects, 
# I'm probably only going to implement storing of a username and password (No Database). 
# And a master password + key combo for authentication
# So the key isnt saved anywhere, its generated on the fly using our master password right?

## How Password Managers work:

# Generate random strong passwords
# Save username, password, and some notes (or extra fields)
# Check whether the master password is strong enough
# A master password and key (256 Bit AES) is enough for local password managers, because theres no server and data transmission involved
# A server key is used in cloud based managers to send the encrypted data to the user, and theres another local key which is used to decrypt our data locally
# Lastpass creates a string by concatting our email and password and then uses HMAC (PBKDF2) to create a hash -- creating a strong hash by hashing it multiple times (around 100K) -- Server Key
# Then our master password is again appended to the newly created Server Key and hashed a few more times (around 5K -- because less processing power) to generate our local key
# Store both of these in a database
# 1Password uses something a bit more different, a public / private key combo (to share vaults), and a Password Authenticated Key Exchange (like diffie-hellman but for passwords) instead of a key derived from the Master Password
