#!/usr/bin/env python3
import argparse
import psycopg2
import sys
import time

if __name__ == '__main__':
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('--db_host', required=True)
    arg_parser.add_argument('--db_port', required=True)
    arg_parser.add_argument('--db_user', required=True)
    arg_parser.add_argument('--db_password', required=True)
    arg_parser.add_argument('--timeout', type=int, default=30)
    arg_parser.add_argument('--database')
    arg_parser.add_argument('--db-filter')
    arg_parser.add_argument('--no-database-list', action='store_true')
    arg_parser.add_argument('--without-demo', action='store_true')
    arg_parser.add_argument('--proxy-mode', action='store_true')
    arg_parser.add_argument('--workers')
    arg_parser.add_argument('--log-level')
    arg_parser.add_argument('--limit-time-cpu')
    arg_parser.add_argument('--limit-time-real')
    arg_parser.add_argument('--load')
    arg_parser.add_argument('--email-from')
    arg_parser.add_argument('--smtp')
    arg_parser.add_argument('--smtp-port')
    arg_parser.add_argument('--smtp-ssl', action='store_true')
    arg_parser.add_argument('--smtp-user')
    arg_parser.add_argument('--smtp-password')

    args = arg_parser.parse_args()

    start_time = time.time()
    while (time.time() - start_time) < args.timeout:
        try:
            conn = psycopg2.connect(user=args.db_user, host=args.db_host, port=args.db_port, password=args.db_password,
                                    dbname='postgres')
            error = ''
            break
        except psycopg2.OperationalError as e:
            error = e
        else:
            conn.close()
        time.sleep(1)

    if error:
        print("Database connection failure: %s" % error, file=sys.stderr)
        sys.exit(1)
