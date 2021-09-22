package controller;

import javax.persistence.NoResultException;
import model.*;

public class DAOJPA {
    public boolean checarCPF (Banco bb, String c) throws Exception
    {
        try
        {
            //se n existir um usuario com esse cpf, dispara-se uma exceção NoResultException
            Usuario obj = (Usuario)bb.sessao.createNamedQuery("Usuario.findByCpf").setParameter("cpf", c).getSingleResult();
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
