import pandas as pd
from sqlalchemy import create_engine



engine = create_engine("mysql+pymysql://root:@localhost/CCA")     # Replace with your database connection string


df = pd.read_sql("SELECT * FROM clientes", engine)


resultado = df.groupby("programa")["valor_financiamento"].agg(["count", "sum"])
print(resultado)

resultado2 = df.groupby(["programa", "agencia"], dropna=False)["valor_financiamento"].agg(
    qtde="count", total_financiado="sum"
    ).sort_values("total_financiado", ascending=False)

# print(resultado2)


# print(df.head())
# print(df.info())

print(resultado2["total_financiado"].sum())
print(resultado2["qtde"].sum())

relatorio = resultado2.reset_index()
relatorio.to_excel("relatorio_cca.xlsx", index=False)


