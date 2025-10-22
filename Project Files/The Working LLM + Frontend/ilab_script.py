import sys
import psycopg2
import pandas as pd

def main():
    if len(sys.argv) < 4:
        print("Usage: python3 ilab_script.py '<SQL_QUERY>' <username> <password>")
        return

    sql_query = sys.argv[1]
    username = sys.argv[2]
    password = sys.argv[3]

    #had help from chatgpt to connect to postgres using psycopg2
    conn = psycopg2.connect(
        host="postgres.cs.rutgers.edu",
        database="jfs199",
        user=username,
        password=password
    )

    try:
        cur = conn.cursor()
        cur.execute(sql_query)
        rows = cur.fetchall()
        colnames = [desc[0] for desc in cur.description]

        # Print results as a DataFrame
        df = pd.DataFrame(rows, columns=colnames)
        print(df.to_string(index=False))

    except Exception as e:
        print(f"Error executing query: {e}")

    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    main()
