/*
DAOJPA =========================================================================
Esta classe possui algumas funções específicas de interação com o banco de dados,
funções que tiveram de ser programadas à mão. São consultas mais complexas.
*/
package controller;

import java.util.Date;
import java.util.List;
import javax.persistence.NoResultException;
import model.*;

public class DAOJPA {
    //Procura e devolve um usuário, enfermeiro ou gestor através de seu CPF. É usada, 
    //por exemplo, no login.
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
    
    //Procura e devolve uma vacina a partir de sua descrição.
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
    
    //Procura e devolve certo agendamento por meio do código do usuário que o fez.
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
    
    //Procura e devolve um lote a partir de sua descrição.
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

    //Procura e devolve uma lista de vacinações que tenham ocorrido no período 
    //estabelecido pelo parâmetros periodoInicio e periodoFim.
    public List<Vacinacao> vacinasPeriodo(Banco bb, Date periodoInicio, Date periodoFim) throws Exception {
        try {
            return bb.sessao.createQuery("SELECT v from Vacinacao v where v.dataAplicacao <= :pF AND v.dataAplicacao >= :pI")
                    .setParameter("pF", periodoFim).setParameter("pI", periodoInicio).getResultList();
        } 
        catch (Exception ex) {
            throw new Exception("Erro no vacinasPeriodo: " + ex.getMessage());
        }
    }
    
    //Procura e devolve os movimentos no estoque, relacionados à entrada e saída,
    //mas não à vacinação, da vacina especificada. Isso está explicado na classe MovimentoVacina.java na pasta model.
    public List<MovimentoVacina> movimentosRelatorio(Banco bb, Vacina v) throws Exception
    {
        try {
            return bb.sessao.createQuery("SELECT m from MovimentoVacina m where m.codigoVacina = :v")
                    .setParameter("v", v).getResultList();
        } 
        catch (Exception ex) {
            throw new Exception("Erro no movimentosRelatorio: " + ex.getMessage());
        }
    }
}
