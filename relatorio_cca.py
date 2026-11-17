import pandas as pd
from sqlalchemy import create_engine

# Leitura e conexão com o banco de dados

engine = create_engine("mysql+pymysql://root:@localhost/CCA")     # Replace with your database connection string


df = pd.read_sql("SELECT * FROM clientes", engine)


# Relatório 1: financiamento por programa e agência


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


# Relatório 2: financiamento por faixa de valor

df["faixa_valor"] = pd.cut(df["valor_financiamento"], bins=[0, 200000, 400000, float("inf")], labels=["0-200k", "200k-400k", "Acima de 400k"], include_lowest=True)

resultado3 = df.groupby("faixa_valor", dropna=False)["valor_financiamento"].agg([("qtde", "count"), ("total_financiado", "sum")])

print(resultado3)
print(resultado3["total_financiado"].sum())


# Relatório 3: prazo da vistoria por credenciado


df["pedido_vistoria"] = pd.to_datetime(df["pedido_vistoria"])
df["retorno_vistoria"] = pd.to_datetime(df["retorno_vistoria"])

df["prazo_vistoria"] = (df["retorno_vistoria"] - df["pedido_vistoria"]).dt.days

resultado4 = df.groupby("credenciado_vistoria", dropna=False)["prazo_vistoria"].agg([("qtde", "count"), ("prazo_medio", "mean")])
resultado4["prazo_medio"] = resultado4["prazo_medio"].round(1)

print(resultado4)

# Criando o excel com os 3 relatorios   

with pd.ExcelWriter("relatorio_cca.xlsx") as writer:
    relatorio.to_excel(writer, sheet_name="Programa e Agência", index=False)
    resultado3.to_excel(writer, sheet_name="Faixa de Valor")
    resultado4.to_excel(writer, sheet_name="Prazo Vistoria")