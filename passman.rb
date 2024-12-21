# A program to encrypt and save your passwords securely


# A function to prompt and get input from the user
def prompt_user(prompt)
  print prompt
  gets.chomp
end

# A function to derive a key from my master password

# A function to authenticate my master password

# A function to encrypt my data using the key

# A function to decrypt my data using the key

# A function to save the encrypted data to disk

# A function to output the decryped data to the user

# Main function
puts prompt_user("name: ")



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
