package controller;

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
}
