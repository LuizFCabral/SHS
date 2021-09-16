/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import model.*;

/**
 *
 * @author Pedro
 */
public class DAOJPA {
    public boolean checarCPF (Banco bb, String c) throws Exception
    {
        try
        {
            Usuario obj = (Usuario)bb.sessao.createNamedQuery("Usuario.findByCpf").setParameter("cpf", c).getSingleResult();
            return true;
        }
        catch(Exception ex)
        {
            if(ex.getMessage().contains("getSingleResult() did not retrieve any entities"))
                return false;
            throw new Exception("Erro no checarCPF: " + ex.getMessage());
        }
    }
}
