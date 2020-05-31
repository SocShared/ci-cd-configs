if [ ! -f .initialized ]; then
    echo "Initializing container"
    # run initializing commands
    touch .initialized
fi

exec sentry upgrade --noinput
exec sentry createuser --email admin@local.ru --password Admin12345 --superuser --no-input