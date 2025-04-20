from sqlalchemy import create_engine, text

url = f"iris://_SYSTEM:SYS@localhost:53795/IRISAPP"
engine = create_engine(url)
with engine.connect() as conn:
    print(conn.execute(text("SELECT 'hello world!'")).first()[0])
