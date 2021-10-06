<%-- 
    Document   : loginUsuario
    Created on : 01/10/2021, 23:29:02
    Author     : Pedro
--%>

<%@page import="controller.UsuarioJpaController"%>
<%@page import="model.Banco"%>
<%@page import="controller.DAOJPA"%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
<%
            request.setCharacterEncoding("UTF-8");
            Usuario obj;
            Banco bb = new Banco();
            
            try
            {
                obj = (Usuario) session.getAttribute("sessao");
                //Se já houver alguém logado...
                if(session.getAttribute("sessao") != null)
                {
                    //Se a pessoa não quiser deslogar
                    if(request.getAttribute("bDeslog") == null)
                    {
%>
                        <h1><%=obj.getNome()%>, você já está logado, deseja deslogar?</h1>
                        <form action="login.jsp" method="post">
                            <input type="submit" name="bDeslog"/>
                        </form>
<%  
                    }
                    //Se a pessoa quiser deslogar
                    else
                    {
                        session.setAttribute("sessao", null);
%>
                    <!-- form para o log-in-->
<%
                    }
                }
                //Se ainda não houver alguém logado...  
                else
                {
                    if(request.getParameter("b1") == null)
                    {
%>
                        <!-- form para o log-in-->
<%
                    }
                    else
                    {
                        DAOJPA daoJ = new DAOJPA();
                        String cpf = request.getParameter("txtCPF");
                        obj = (Usuario) daoJ.searchCPF(bb, cpf, obj.getClass());
                        if(obj == null)
                        {
                            throw new Exception("CPF não cadastrado!");
                        }
                        else
                        {
                            Banco.conexao.close();
                            session.setAttribute("sessao", obj);
%>
                            <h1>Log-in feito com sucesso!</h1>
<%
                        }
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
