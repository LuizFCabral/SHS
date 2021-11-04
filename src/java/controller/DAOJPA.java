package controller;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import javax.persistence.NoResultException;
import model.*;

public class DAOJPA {
    public Object searchCPF (Banco bb, String c, Class tipo) throws Exception
    {
        try
        {
            if(tipo == Usuario.class)
            {
                //se n existir um usuario com esse cpf, dispara-se uma exceção NoResultException
                return bb.sessao.createNamedQuery("Usuario.findByCpf").setParameter("cpf", c).getSingleResult();
            }
            if(tipo == UsuarioApl.class)
            {
                //se n existir um usuario com esse cpf, dispara-se uma exceção NoResultException
                return bb.sessao.createNamedQuery("UsuarioApl.findByCpf").setParameter("cpf", c).getSingleResult();
            }
            throw new Exception("Classe desconhecida");
        }
        catch(NoResultException ex) 
        {
            return null;
        }
        catch(Exception ex)
        {
            throw new Exception("Erro no searchCPF: " + ex.getMessage());
        }
    }
    
    public Vacina vacinaByDescr(Banco bb, String descr) throws Exception
    {
        try
        {
            return (Vacina) bb.sessao.createNamedQuery("Vacina.findByDescricao").setParameter("descricao", descr).getSingleResult();
        }
        catch(Exception ex)
        {
            throw new Exception("Erro no vacinaByDescr: " + ex.getMessage());
        }
    }
    
    public Agenda agendaByCodigoUsuario(Banco bb, int codigo) throws Exception
    {
        try
        {
            return (Agenda)bb.sessao.createNamedQuery("Agenda.findByCodigoUsuario").setParameter("codigo", codigo).getSingleResult();
        }
        catch(NoResultException ex) 
        {
            return (null);
        }
        catch(Exception ex)
        {
            throw new Exception("Erro no agendaByCodigoUsuario: " + ex.getMessage());
        }
    }
    
    public Lote loteByDescricao(Banco bb, String descricao) throws Exception {
        try {
            return (Lote)bb.sessao.createNamedQuery("Lote.findByDescricao").setParameter("descricao", descricao).getSingleResult();
        }
        catch(NoResultException ex) 
        {
            return (null);
        }
        catch(Exception ex) {
            throw new Exception("Erro no codigoLoteByDescricao: " + ex.getMessage());
        }
    }

    public int pessoasVacinadas(Banco bb, Date periodoInicio, Date periodoFim) throws Exception {
        try {
            return  (int)bb.sessao.createQuery("SELECT SUM(v.codigo_usuario) FROM Vacinacao v WHERE v.data_aplicacao >= :periodoInicio AND v.data_aplicacao <= :periodoFim")
                    .setParameter("periodoInicio", periodoInicio)
                    .setParameter("periodoFim", periodoFim)
                    .getSingleResult();
        } 
        catch (Exception ex) {
            throw new Exception("Erro no pessoasVacinadas(): " + ex.getMessage());
        }
    }
    
    public ArrayList<String> movimentacaoEstoqueVacina(Banco bb, Date periodoInicio, Date periodoFim) throws Exception {
        VacinaJpaController dao;
        int qtde, movP = 0, movN = 0; //qtde de vacinas; movimento positivo; movimento negativo
        ArrayList<String> movEstoque; //dados finais
        ArrayList<Vacina> listaVacina; //lista de vacinas
        ArrayList<MovimentoVacina> lstVacMovs; //lista de vacinas
        Vacina vacina;
        
        try {
            dao = new VacinaJpaController(bb.conexao);
            qtde = (int)bb.sessao.createNamedQuery("Vacina.countByCodigo").getSingleResult();
            movEstoque = new ArrayList<>();
            listaVacina = (ArrayList<Vacina>)bb.sessao.createQuery("SELECT ");
            for(int i = 0; i < qtde; i++) {
                vacina = listaVacina.get(i);
                movEstoque.add(vacina.getDescricao());
                
                //SOMA DE MOVIMENTOS
                lstVacMovs = (ArrayList<MovimentoVacina>)vacina.getMovimentoVacinaList();
                for(MovimentoVacina mov : lstVacMovs) {
                    if(mov.getTipoMovimento().equalsIgnoreCase("E"))
                        movP++;
                    if(mov.getTipoMovimento().equalsIgnoreCase("S"))
                        movN++;
                }
            }
            return (movEstoque);
        } 
        catch(Exception ex) {
            throw new Exception("Erro no movimentacaoEstoqueVacina(): " + ex.getMessage());
        }
    }
}
