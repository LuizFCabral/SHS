package controller;

import java.util.Date;
import java.util.List;
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

    public List<Vacinacao> vacinasPeriodo(Banco bb, Date periodoInicio, Date periodoFim) throws Exception {
        try {
            return bb.sessao.createQuery("SELECT v from Vacinacao v where v.dataAplicacao <= :pF AND v.dataAplicacao >= :pI")
                    .setParameter("pF", periodoFim).setParameter("pI", periodoInicio).getResultList();
        } 
        catch (Exception ex) {
            throw new Exception("Erro no vacinasPeriodo: " + ex.getMessage());
        }
    }
    
    public List<MovimentoVacina> movimentosRelatorio(Banco bb, Date periodoInicio, Date periodoFim, Vacina v) throws Exception
    {
        try {
            return bb.sessao.createQuery("SELECT m from MovimentoVacina where m.codigoVacina.descricao = :v AND where m.dataMovimento <= :pF AND where m.dataMovimento >= :pI")
                    .setParameter("pF", periodoFim).setParameter("pI", periodoInicio).setParameter("v", v.getDescricao()).getResultList();
        } 
        catch (Exception ex) {
            throw new Exception("Erro no vacinasPeriodo: " + ex.getMessage());
        }
    }
}
