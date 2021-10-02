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
            boolean usouBanco = false;
            Usuario obj;
            try
            {
                obj = (Usuario) session.getAttribute("sessao");
                if(session.getAttribute("sessao") != null)
                {
                    if(request.getAttribute("bDeslog") == null)
                    {
                        %><h1><%=obj.getNome()%>, você já está logado, deseja deslogar?</h1>
                        <form action="login.jsp" method="post">
                            <input type="submit" name="bDeslog"/>
                        </form>
                        <%  
                    }
                    else
                    {
                        %>
                    <!-- form para o log-in-->
                    <%
                    }

                }
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
                        Banco bb = new Banco();
                        usouBanco = true;
                        DAOJPA daoJ = new DAOJPA();
                        String cpf = request.getParameter("txtCPF");
                        boolean achou = daoJ.checarCPF(bb, cpf, obj.getClass());
                        if(!achou)
                        {
                            throw new Exception("CPF não cadastrado!");
                        }
                        else
                        {
                            obj = (Usuario) daoJ.getByCPF(bb, cpf, obj.getClass());
                            Banco.conexao.close();
                            session.setAttribute("sessao", obj);
                            %><h1>Log-in feito com sucesso!</h1><%
                        }
                    }
                }
            }
            catch(Exception ex)
            {
                if(usouBanco)
                    Banco.conexao.close();
                %><h1>Erro: <%=ex.getMessage()%></h1><%
            }
        %>
    </body>
</html>
