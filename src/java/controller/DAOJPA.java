package controller;

import java.sql.Timestamp;
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
    public Agenda agendaVigente(Banco bb, Usuario u) throws Exception{
        try
        {
            Timestamp hoje = new Timestamp(System.currentTimeMillis());
            return (Agenda)bb.sessao.createQuery("select a from Agenda a where a.codigo_usuario = :u AND a.data_vacinacao = :hoje")
                    .setParameter("u", u).setParameter("hoje", hoje).getSingleResult();
        }
        catch(Exception ex)
        {
            throw new Exception("Erro no agendaVigente: " + ex.getMessage());
        }
    }
}
