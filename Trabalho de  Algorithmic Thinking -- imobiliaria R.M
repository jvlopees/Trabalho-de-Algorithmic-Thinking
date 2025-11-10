import csv

class Imovel:
    def __init__(self, tipo, quartos=1, garagem=False, vagas_estudio=0, sem_crianca=False):
        self.tipo = tipo.lower()
        self.quartos = quartos
        self.garagem = garagem
        self.vagas_estudio = vagas_estudio
        self.sem_crianca = sem_crianca

    def calcular_aluguel(self):
        # Valores base
        if self.tipo == "apartamento":
            valor = 700
        elif self.tipo == "casa":
            valor = 900
        elif self.tipo == "estudio":
            valor = 1200
        else:
            return 0

        # Quartos extra
        if self.tipo == "apartamento" and self.quartos == 2:
            valor += 200
        if self.tipo == "casa" and self.quartos == 2:
            valor += 250

        # Garagem
        if self.tipo in ["apartamento", "casa"] and self.garagem:
            valor += 300

        # Estúdio vagas
        if self.tipo == "estudio":
            if self.vagas_estudio >= 2:
                valor += 250
            if self.vagas_estudio > 2:
                valor += (self.vagas_estudio - 2) * 60

        # Desconto p/ quem não tem criança (somente apartamento)
        if self.tipo == "apartamento" and self.sem_crianca:
            valor *= 0.95

        return valor

def gerar_csv(valor_mensal):
    parcelas = []
    for i in range(1, 13):
        parcelas.append([f"Mês {i}", f"R$ {valor_mensal:.2f}"])

    with open("parcelas_aluguel.csv", "w", newline="", encoding="utf-8") as arquivo:
        escritor = csv.writer(arquivo)
        escritor.writerow(["Parcela", "Valor"])
        escritor.writerows(parcelas)

    print("\nArquivo 'parcelas_aluguel.csv' gerado com sucesso!\n")

def main():
    print("=== SISTEMA DE ORÇAMENTO DE IMÓVEIS R.M ===\n")

    tipo = input("Tipo de imóvel (apartamento / casa / estudio): ")

    if tipo.lower() in ["apartamento", "casa"]:
        quartos = int(input("Quantidade de quartos (1 ou 2): "))
        garagem = input("Deseja garagem? (s/n): ").lower() == "s"
        sem_crianca = input("Possui crianças? (s/n): ").lower() == "n"
        imovel = Imovel(tipo, quartos, garagem, sem_crianca=sem_crianca)

    elif tipo.lower() == "estudio":
        vagas = int(input("Quantidade de vagas de estacionamento: "))
        imovel = Imovel(tipo, vagas_estudio=vagas)

    else:
        print("Tipo inválido!")
        return

    valor_mensal = imovel.calcular_aluguel()
    print(f"\nValor mensal do aluguel: R$ {valor_mensal:.2f}")

    contrato = 2000 / 5
    print(f"Valor do contrato (parcelado em até 5x): R$ {contrato:.2f} por mês")

    gerar = input("\nDeseja gerar arquivo CSV com as 12 parcelas? (s/n): ")
    if gerar.lower() == "s":
        gerar_csv(valor_mensal)

    print("\nOrçamento concluído. Obrigado!")

main()
