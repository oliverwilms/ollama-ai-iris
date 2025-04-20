from sqlalchemy import create_engine, text

url = f"iris://teste:teste@localhost:51774/TESTE"
engine = create_engine(url)
with engine.connect() as conn:
    print(conn.execute(text("SELECT 'hello world!'")).first()[0])
