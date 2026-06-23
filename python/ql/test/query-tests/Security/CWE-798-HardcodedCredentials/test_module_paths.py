# Test that dotted module/class paths are not flagged as hardcoded credentials.
# These are commonly used in Django settings for PASSWORD_HASHERS, backends, etc.

PASSWORD_HASHERS = [
    "django.contrib.auth.hashers.PBKDF2PasswordHasher",
    "django.contrib.auth.hashers.PBKDF2SHA1PasswordHasher",
    "django.contrib.auth.hashers.Argon2PasswordHasher",
]

AUTHENTICATION_BACKENDS = [
    "django.contrib.auth.backends.ModelBackend",
    "allauth.account.auth_backends.AuthenticationBackend",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
]

# This should still be flagged - actual credential
def connect():
    client.connect(password="s3cr3t_passw0rd_12345")  # this is a real credential
