package controller;

import javax.persistence.NoResultException;
import model.*;

public class DAOJPA {
    public boolean checarCPF (Banco bb, String c, Class tipo) throws Exception
    {
        try
        {
            if(tipo == Usuario.class)
            {
            //se n existir um usuario com esse cpf, dispara-se uma exceção NoResultException
            Usuario obj = (Usuario)bb.sessao.createNamedQuery("Usuario.findByCpf").setParameter("cpf", c).getSingleResult();
            }
            if(tipo == UsuarioApl.class)
            {
            //se n existir um usuario com esse cpf, dispara-se uma exceção NoResultException
            UsuarioApl obj = (UsuarioApl)bb.sessao.createNamedQuery("UsuarioApl.findByCpf").setParameter("cpf", c).getSingleResult();
            }
            return true;
        }
        catch(NoResultException ex) 
        {
            return false;
        }
        catch(Exception ex)
        {
            throw new Exception("Erro no checarCPF: " + ex.getMessage());
        }
    }
}
