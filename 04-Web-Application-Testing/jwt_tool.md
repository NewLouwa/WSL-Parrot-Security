# jwt_tool

## Purpose
JWT (JSON Web Token) testing and exploitation toolkit. Decodes, tampers, and attacks JWT tokens to find authentication bypass vulnerabilities including signature bypass, key confusion, and brute-force attacks.

## Installation
```bash
git clone https://github.com/ticarpi/jwt_tool.git
cd jwt_tool
pip install -r requirements.txt
chmod +x jwt_tool.py

# Optional: symlink for easy access
sudo ln -s $(pwd)/jwt_tool.py /usr/local/bin/jwt_tool
```

## Quick Start
```bash
# Decode and display a JWT
python3 jwt_tool.py <JWT_TOKEN>

# Run all known attack modes
python3 jwt_tool.py <JWT_TOKEN> -M at

# Tamper with claims (interactive)
python3 jwt_tool.py <JWT_TOKEN> -T

# Test for algorithm confusion (none attack)
python3 jwt_tool.py <JWT_TOKEN> -X a

# Brute-force the HMAC secret key
python3 jwt_tool.py <JWT_TOKEN> -C -d /usr/share/wordlists/rockyou.txt
```

## Common Patterns
```bash
# None algorithm attack (bypass signature verification)
python3 jwt_tool.py <JWT_TOKEN> -X a

# Key confusion attack (RS256 to HS256)
python3 jwt_tool.py <JWT_TOKEN> -X k -pk public.pem

# Inject a custom claim value
python3 jwt_tool.py <JWT_TOKEN> -I -pc role -pv admin

# Sign with a known key
python3 jwt_tool.py <JWT_TOKEN> -I -pc sub -pv admin -S hs256 -p "secret_key"

# JWKS injection attack
python3 jwt_tool.py <JWT_TOKEN> -X i
```

## HTB Usage
- Decode JWTs found in cookies or Authorization headers during web challenges
- Try `none` algorithm attack first as a quick win on older implementations
- Brute-force weak HMAC secrets with rockyou or custom wordlists
- Key confusion (RS256 -> HS256) is a common HTB vulnerability pattern
- Tamper claims like `role`, `admin`, `sub` to escalate privileges
- Use `-M at` to automatically run all attacks when you need a quick check
