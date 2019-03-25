echo "Setting umask to 0000"
umask 0000
echo "executing entrypoint.sh $@"
exec /bin/entrypoint.sh "$@"
