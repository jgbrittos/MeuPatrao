import Foundation

let mediaDeDiasUteisEmUmAno = 252
let mediaDeDiasEmUmMes = 30

extension Int {
    var reais: Int { return self }
    var dia: Int { return self }
    var dias: Int { return self }
    var mes: Int { return mediaDeDiasEmUmMes }
    var meses: Int { return self * mes }
    var ano: Int { return mediaDeDiasUteisEmUmAno }
    var anos: Int { return self * ano }
//    var eMeio: Int { return self + self / 2 }
}
extension Double {
    var reais: Double { return self }
    var porCento: Double { return self / 100.0 }
    var emPorcentagem: Double { return self * 100.0 }
    var formatada: String {
        return String(format: "%g", self) + "%"
    }
    func da(_ taxa: Double) -> Double {
        return self * taxa
    }
    
    var aoAnoParaAoMes: Double {
        return (pow(1 + self, 1/12.0) - 1).emPorcentagem
    }
    
    var aoAnoParaAoDia: Double {
        return (pow(1 + self, Double(1 / 252.0)) - 1).emPorcentagem
    }
    
    var aoMesParaAoAno: Double {
        return (pow(1 + self, 12) - 1).emPorcentagem
    }
}
extension String {
    var aoDia: String {
        return self + " a.d"
    }
    
    var aoMes: String {
        return self + " a.m"
    }
    
    var aoAno: String {
        return self + " a.a"
    }
}

enum RendaFixa {
    case CDB
    case LCI
    case LCA
    case LC
    case TD_Selic
    case TD_Prefixado
    case TD_IPCA
}
enum Taxa: Double {
    case CDI = 6.4
    case IPCA = 3.78
    case IGP_M = 6.74
    case CUSTOM = 0.0
}
enum ImpostoDeRenda: Double {
    case isento = 0.0
    case IR_22_5 = 22.5
    case IR_20 = 20.0
    case IR_17_5 = 17.5
    case IR_15 = 15.0
}
enum IRRegressivo: Double {
    case seisMeses = 6
    case umAno = 12
    case umAnoEMeio = 18
    case doisAnos = 24
}

class MeuPatrao {
    //Pós fixados atrelados a qualquer taxa, mas sem variação da taxa no período
    
    var montanteInicial: Double = 1000.0
    var periodo: Int = 1.ano
    var total: Double = 1000.0
    var rentabilidade: Double = 100.porCento
    var rentabilidadeDiaria: Double = 0.0
    var taxaAtrelada: Taxa = .CDI
    var taxa: Double {
        return taxaAtrelada.rawValue.porCento
    }
    var taxaCustom: Double = 0.0
    var taxaInformada: Double {
        return taxaAtrelada == .CUSTOM ? taxaCustom : taxa
    }
    var rentabilidadeMensal: Double {
        let taxaInformada = taxaAtrelada == .CUSTOM ? taxaCustom : taxa
        return rentabilidade.da(taxaInformada).aoAnoParaAoMes
    }
    
    func considereUmMontanteInicial(de valor: Double) -> Self {
        montanteInicial = valor
        total = valor
        return self
    }
    
    func considereUmPeriodo(de tempo: Int) -> Self {
        periodo = tempo
        return self
    }
    
    func considereUmaRentabilidade(de r: Double)  -> Self {
        rentabilidade = r
        return self
    }
    
    func esseInvestimentoEhAtreladoAo(_ t: Taxa) -> Self {
        taxaAtrelada = t
        return self
    }
    
    func considereATaxaNoPeriodo(como valor: Double)  -> Self {
        taxaAtrelada = Taxa(rawValue: valor) ?? .CUSTOM
        taxaCustom = taxaAtrelada == .CUSTOM ? valor : 0.0
        return self
    }
    
    func eMeMostraOsResultados() -> Self {
        print("## ------------ Só confirmando os valores mesmo... ------------ ##\n")
        print("\t\t\t\t      Período: \(periodo) dias\n")
        print("\t\t\t\t  Lucro líquido: R$", String(format: "%.2f", total - montanteInicial), "\n")
        print("\t\t\t\t Montante final: R$", String(format: "%.2f", total), "\n")
        print("\t\t\t\tMontante inicial: R$", String(format: "%.2f", montanteInicial), "\n")
        print("## --------------- Acho que tá tudo Ok mesmo... --------------- ##\n\n\n\n")
        return self
    }
    
    func eFaleAVerdadeAoFimDeTudo() {
        print("\n\n\n\n\n\n\n\n\n")
        print("(.)(.) pq com peitos sempre fica melhor...\n")
        print("e não se esqueça...\n")
        print("a máfia está sempre de olho...")
        print("(-.(-.(-.(-.(-.(-.(-.(-.(-.(-.(-.-).-).-).-).-).-).-).-).-).-).-)\n")
    }
    
    func eQueroSaberAsTaxasTambem() -> Self {
        print("\t\t\t\t\t\t__Taxas__\n")
        print("##        Toma essas porra (seu exigente do caralho...)         ##\n")
        print("##    [até parece que sabe de alguma coisa...estrupício...]     ##\n")
        print("\t\t\t Rentabilidade diária: \((rentabilidadeDiaria - 1).emPorcentagem.formatada.aoDia)\n")
        print("\t\t\t Rentabilidade mensal: \(rentabilidadeMensal.formatada.aoMes)\n")
        print("\t\t  Rentabilidade anual (\(rentabilidade.emPorcentagem.formatada) do \(taxaAtrelada)): \((rentabilidade.emPorcentagem * taxaInformada).formatada.aoAno)\n")
        print("## Agora sim!? Obrigado. Até semana que vem... #partiu  #sextou ##")
        return self
    }
    
    func agoraDaTeusPulo() -> Self {
        rentabilidadeDiaria = 1 + rentabilidade.da(taxaInformada).aoAnoParaAoDia.porCento
        
        for _ in 0..<periodo { total *= rentabilidadeDiaria }
        
        return self
    }
}

class MeuConterraneo: MeuPatrao {
    //Híbridos sem variacao de taxa pós fixada no período
    var rentabilidadePrefixada: Double = 0.porCento
    
    override var rentabilidadeMensal: Double {
        return rentabilidade.da(taxa + rentabilidadePrefixada).aoAnoParaAoMes
    }
    
    func considereUmaRentabilidadePrefixada(de r: Double)  -> Self {
        rentabilidadePrefixada = r
        return self
    }
    
    override func eQueroSaberAsTaxasTambem() -> Self {
        print("\t\t\t\t\t\t__Taxas__\n")
        print("##        Toma essas porra (seu exigente do caralho...)         ##\n")
        print("##    [até parece que sabe de alguma coisa...estrupício...]     ##\n")
        print("\t\t\t Rentabilidade diária: \((rentabilidadeDiaria - 1).emPorcentagem.formatada.aoDia)\n")
        print("\t\t\t Rentabilidade mensal: \(rentabilidadeMensal.formatada.aoMes)\n")
        print("\t\t\t\tRentabilidade Pré bruta: \(rentabilidadePrefixada.emPorcentagem.formatada.aoAno)\n")
        print("\t\t\t Rentabilidade Pós bruta (\(taxaAtrelada)): \(taxaInformada.emPorcentagem.formatada.aoAno)\n")
        print("\t\t\t Rentabilidade média no período: \((rentabilidadePrefixada + taxaInformada).emPorcentagem.formatada.aoAno)\n")
        print("## Agora sim!? Obrigado. Até semana que vem... #partiu  #sextou ##\n")
        return self
    }
    
    override func agoraDaTeusPulo() -> Self {
        rentabilidadeDiaria = 1 + rentabilidade.da(taxaInformada + rentabilidadePrefixada).aoAnoParaAoDia.porCento
        
        for _ in 0..<periodo { total *= rentabilidadeDiaria }
        
        return self
    }
}

class MeuConsagrado: MeuPatrao {
    //Esse considera IR
    var tipo: RendaFixa = .LCI
    var impostoDeRendaAplicado: ImpostoDeRenda {
        switch tipo {
        case .CDB, .LC, .TD_IPCA, .TD_Selic, .TD_Prefixado:
            if periodo <= 6.meses {
                return .IR_22_5
            } else if periodo > 6.meses && periodo <= 12.meses {
                return .IR_20
            } else if periodo > 12.meses && periodo <= 24.meses {
                return .IR_17_5
            } else {
                return .IR_15
            }
        case .LCI, .LCA: return .isento
        }
    }
    var impostoDeRenda: ImpostoDeRenda = .IR_22_5
    
    var ir: Double {
        return 1 - impostoDeRendaAplicado.rawValue.porCento
    }
    
    func considereUmImpostoDeRendaDe(_ ir: ImpostoDeRenda) -> Self {
        impostoDeRenda = ir
        return self
    }
    
    func calculaPraMimUm(_ t: RendaFixa) -> Self {
        tipo = t
        return self
    }
    
    override func agoraDaTeusPulo() -> Self {
        rentabilidadeDiaria = 1 + rentabilidade.da(taxaInformada).aoAnoParaAoDia.porCento
        
        for _ in 0..<periodo { total *= rentabilidadeDiaria }
        
        menosImpostoDeRenda()
        
        return self
    }
    
    func menosImpostoDeRenda() {
        total = ((total - montanteInicial) * ir) + montanteInicial
    }
}


MeuConsagrado()
    .calculaPraMimUm(.CDB)
    .esseInvestimentoEhAtreladoAo(.CDI)
    .considereUmaRentabilidade(de: 115.porCento)
    .considereUmMontanteInicial(de: 10000.reais)
    .considereUmPeriodo(de: 2.anos - 2.dias)
    .agoraDaTeusPulo()
    .eMeMostraOsResultados()
    .eQueroSaberAsTaxasTambem()

//MeuConterraneo()
//    .considereUmMontanteInicial(de: 10000.reais)
//    .considereUmPeriodo(de: 2.anos - 4.dias)
//    .considereATaxaNoPeriodo(como: 15.porCento)
//    .agoraDaTeusPulo()
//    .eMeMostraOsResultados()
//    .eQueroSaberAsTaxasTambem()
//MeuPatrao()
//    .esseInvestimentoEhAtreladoAo(.CDI)
//    .considereUmMontanteInicial(de: 10000.reais)
//    .considereUmPeriodo(de: 2.anos - 4.dias)
//    .considereUmaRentabilidade(de: 100.porCento)
//    .considereATaxaNoPeriodo(como: 6.5.porCento)
//    .agoraDaTeusPulo()
//    .eMeMostraOsResultados()
//    .eQueroSaberAsTaxasTambem()
//
//MeuConterraneo()
//    .esseInvestimentoEhAtreladoAo(.IPCA)
//    .considereUmMontanteInicial(de: 10000.reais)
//    .considereUmPeriodo(de: 2.anos - 4.dias)
//    .considereUmaRentabilidadePrefixada(de: 2.62.porCento)
//    .considereATaxaNoPeriodo(como: 4.porCento)
//    .agoraDaTeusPulo()
//    .eMeMostraOsResultados()
//    .eQueroSaberAsTaxasTambem()


