<%-- 
    Document   : atualizarVacina
    Created on : 09/10/2021, 17:14:15
    Author     : Pedro
--%>

<%@page import="java.util.Date"%>
<%@page import="model.MovimentoVacina"%>
<%@page import="model.Vacina"%>
<%@page import="controller.UsuarioJpaController"%>
<%@page import="controller.DAOJPA"%>
<%@page import="model.Banco"%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Confirmar aplicação de vacina</title>
    </head>
    <body>
        <%
            request.setCharacterEncoding("UTF-8");
            try
            {
                if(request.getParameter("b1") == null)
                {
                 %> <!-- form aqui--><%
                }
                else
                {
                    if(request.getParameter("b1").equalsIgnoreCase("confirmar"))
                    {
                        Date d = new Date();
                        Usuario u = new Usuario();
                        Vacina v = new Vacina();
                        UsuarioJpaController daoU = new UsuarioJpaController(Banco.conexao);
                        DAOJPA daoJ = new DAOJPA();
                        Banco bb = new Banco();
                        int cod = Integer.parseInt(request.getParameter("txtCodigo"));
                        u = daoU.findUsuario(cod); //pega o obj usuário 
                        String descr = request.getParameter("txtDescr");
                        v = daoJ.vacinaByDescr(bb, descr); //pega o obj vacina
                        MovimentoVacina mov = new MovimentoVacina();
                        mov.setTipoMovimento("S");
                        mov.setVacina(v);
                        mov.setQtde(1);
                        int lote = Integer.parseInt("txtLote");
                        mov.setLote(lote);
                        mov.setDataMovimento(d);
                        Banco.conexao.close();
                    }
                }
            }
            catch(Exception ex)
            {
                Banco.conexao.close();
%>
                <h1>Erro: <%=ex.getMessage()%></h1>
<%
            }
        %>
    </body>
</html>
