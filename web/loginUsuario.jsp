<%-- 
    Document   : loginUsuario
    Created on : 01/10/2021, 23:29:02
    Author     : Pedro
--%>

<%@page import="model.UsuarioApl"%>
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
            Object obj;
            Banco bb = new Banco();
            
            try
            {
                obj = session.getAttribute("login");
                //Se já houver alguém logado...
                if(obj != null)
                {
                    //Se a pessoa não quiser deslogar
                    if(request.getParameter("bDeslog") == null)
                    {
                        String nome = "";
                        if(session.getAttribute("classe").equals(Usuario.class))
                        {
                            nome = ((Usuario) obj).getNome();
                        }
                        if(session.getAttribute("classe").equals(UsuarioApl.class))
                        {
                            nome = ((UsuarioApl) obj).getNome();
                        }
%>                      
                        <h1><%=nome%>, você já está logado, deseja deslogar?</h1>
                        <form action="loginUsuario.jsp" method="post">
                            <input type="submit" name="bDeslog" value="Deslogar"/>
                        </form>
<%  
                    }
                    //Se a pessoa quiser deslogar
                    else
                    {
                        session.setAttribute("login", null);
%>
                        <form action="loginUsuario.jsp" method="post">
                            CPF: <input type="text" name="txtCPF"> <br/>
                            Usuário: <input type="radio" name="rdbUser" value="0" checked="checked" /> 
                            Enfermeiro/gestor: <input type="radio" name="rdbUser" value="1"/> <br/>
                            <input type="submit" value="logar" name="b1"> <br/>
                        </form>
<%
                    }
                }
                //Se ainda não houver alguém logado...  
                else
                {
                    if(request.getParameter("b1") == null)
                    {
%>
                        <form action="loginUsuario.jsp" method="post">
                            CPF: <input type="text" name="txtCPF"> <br/>
                            Usuário: <input type="radio" name="rdbUser" value="0" checked="checked" /> 
                            Enfermeiro/gestor: <input type="radio" name="rdbUser" value="1"/> <br/>
                            <input type="submit" value="logar" name="b1"> <br/>
                        </form>
                        <br/><br/>
                        <h3>Usuário novo? Cadastre-se abaixo!</h3>
                        <form action="cadastrar.jsp" method="post" onsubmit="return verificar(1)">
                            Código: <input type="text" name="txtCod" id="idCod" readonly/> <br/>
                            Nome: <input type="text" name="txtNome" id="idNome"/> <br/>
                            CPF: <input type="text" name="txtCPF" id="idCPF" onblur="validaCPF()"/> <br/>
                            Data de nascimento: <input type="text" name="txtDataNasc" id="idDataNasc"/> <br/>
                            Cidade: <input type="text" name="txtCidade" id="idCidade"/><br/><br/>
                            <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>
                        </form>
<%
                    }
                    else
                    {
                        DAOJPA daoJ = new DAOJPA();
                        String cpf = request.getParameter("txtCPF");
                        if(request.getParameter("rdbUser").equals("0"))
                        {
                            Usuario u = new Usuario();
                            u = (Usuario) daoJ.searchCPF(bb, cpf, u.getClass());
                            if(u == null)
                            {
                                throw new Exception("CPF não cadastrado!");
                            }
                            else
                            {
                                Banco.conexao.close();
                                session.setAttribute("classe", u.getClass());
                                session.setAttribute("login", u);
                                %>
                                <h1>Log-in feito com sucesso!</h1>
                                Ir à <a href="agenda.jsp">sua página de agendamentos</a><br/>
                                Ir à <a href="index.jsp">tela inicial</a>
                        <%
                            }
                        }
                        if(request.getParameter("rdbUser").equals("1"))
                        {
                            UsuarioApl u = new UsuarioApl();
                            u = (UsuarioApl) daoJ.searchCPF(bb, cpf, u.getClass());
                            if(u == null)
                            {
                                throw new Exception("CPF não cadastrado!");
                            }
                            else
                            {
                                
                                session.setAttribute("classe", u.getClass());
                                session.setAttribute("login", u);
                                Banco.conexao.close();
%>
                                <h1>Log-in feito com sucesso!</h1>
                                Ir à <a href="index.jsp">tela inicial</a>
<%                                      
                            }
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
