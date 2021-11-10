<%-- 
LOGIN DE USUÁRIO================================================================
Esta é a primeira página do site. Nela, uma pessoa poderá cadastrar-se no site ou 
fazer seu log-in. A depender do tipo de usuário, que é especificado no cadastro, 
ele terá maior ou menor acesso às funcionalidades do site. Um usuário comum, que
representa um cidadão que deseja agendar sua vacinação, não pode modificar o 
cadastro de nenhum outro usuário, gestor ou enfermeiro, por exemplo.
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
        <title>Log-in</title>
        <link rel="stylesheet" href="estilo/style.css">
        <script type="text/javascript">
            var show = false;
            
            //Esta função revela todo o formulário para cadastro de um novo 
            //usuário, enfermeiro ou gestor, que, por padrão, permanece oculto.
            function revelar()
            {
                document.getElementById("fCadastro").hidden = show;
                if(show)
                {
                    document.getElementById("idControle").innerHTML = "Expandir cadastro⏵";
                }
                else
                {
                    document.getElementById("idControle").innerHTML = "Expandir cadastro⏷";
                }
                show = !show;
            }
            function iniciarCadastro(p)
            {
                document.getElementById("dCadastro").hidden = !p;
            }
        </script>
    </head>
    <body>
        <div class="home_content">
        <div class="title">Log-in de usuário</div>
<%
            //VARIÁVEIS
            request.setCharacterEncoding("UTF-8");
            Object obj;
            Banco bb = new Banco();
            
            try
            {
                obj = session.getAttribute("login");
                //1. Alguém já está logado
                if(obj != null)
                {
                    //1.1 Usuário logado não deseja deslogar
                    if(request.getParameter("bDeslog") == null)
                    {
                        String nome = "";
                        if(session.getAttribute("classe").equals(Usuario.class))
                        {
                            nome = ((Usuario)obj).getNome();
                        }
                        if(session.getAttribute("classe").equals(UsuarioApl.class))
                        {
                            nome = ((UsuarioApl)obj).getNome();
                        }
%>                      
                        <h1><%=nome%>, você já está logado, deseja deslogar?</h1>
                        <form action="index.jsp" method="post">
                            <div class="button">
                                <input type="submit" name="bDeslog" value="Deslogar"/>
                            </div>
                        </form>
                        <h1>Clique <a href="hub.jsp">aqui</a> para voltar ao sistema</h1>
<%  
                    }
                    //1.2 Usuário logado deseja deslogar
                    else
                    {
                        session.setAttribute("login", null);
%>
                        <form action="index.jsp" method="post">
                            <div class="user-data">
                                <div class="input-box">
                                    <span class="data">CPF</span>
                                    <input type="text" name="txtCPF" placeholder="Insira o seu CPF">
                                </div>
                            </div>
                            <div class="user-type">
                                <span class="title-type">Tipo de usuário</span><br/>
                                <div class="category">
                                    <span>Usuário comum</span>
                                    <input type="radio" name="rdbUser" value="0" checked="checked" onclick="iniciarCadastro(true)"/> 
                                    <span>Enfermeiro/gestor</span>
                                    <input type="radio" name="rdbUser" value="1" onclick="iniciarCadastro(false)"/>
                                </div>
                            </div>
                            <div class="button">
                                <input type="submit" value="logar" name="b1">
                            </div>
                        </form>
                        <div id="dCadastro">
                            <h3>Usuário novo? <b id='idControle' onclick="revelar()">Expandir cadastro⏵</b></h3>
                            <form hidden="true" action="cadastrar.jsp" method="post" id="fCadastro" onsubmit="return verificar(1)">
                                <div class="user-data">
                                    <div class="input-box">
                                        <span class="data">Nome</span>
                                        <input type="text" name="txtNome" id="idNome" placeholder="Insira o seu nome"/>
                                    </div>
                                    <div class="input-box">
                                        <span class="data">CPF</span>
                                        <input type="text" name="txtCPF" id="idCPF" onblur="validaCPF()" placeholder="Insira o seu CPF"/>
                                    </div>
                                    <div class="input-box">
                                        <span class="data">Data de nascimento</span>
                                        <input type="text" name="txtDataNasc" id="idDataNasc" placeholder="Insira a sua data de nascimento"/>
                                    </div>
                                    <div class="input-box">
                                        <span class="data">Cidade</span>
                                        <input type="text" name="txtCidade" id="idCidade" placeholder="Insira a cidade"/>
                                    </div>
                                </div>
                                <div class="button">
                                    <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>
                                </div>
                            </form>
                        </div>
<%
                    }
                }
                //2. Ninguém está logado
                else
                {
                    //2.1 Formulário para fazer o login
                    if(request.getParameter("b1") == null)
                    {
%>
                        <form action="index.jsp" method="post">
                            <div class="user-data">
                                <div class="input-box">
                                    <span class="data">CPF</span>
                                    <input type="text" name="txtCPF" placeholder="Insira o seu CPF">
                                </div>
                            </div>
                            <div class="user-type">
                                <span class="title-type">Tipo de usuário</span><br/>
                                <div class="category">
                                    <span>Usuário comum</span>
                                    <input type="radio" name="rdbUser" value="0" checked="checked" onclick="iniciarCadastro(true)"/> 
                                    <span>Enfermeiro/gestor</span>
                                    <input type="radio" name="rdbUser" value="1" onclick="iniciarCadastro(false)"/>
                                </div>
                            </div>
                            <div class="button">
                                <input type="submit" value="logar" name="b1">
                            </div>
                        </form>
                        <div id="dCadastro">
                            <h3>Usuário novo? <b id='idControle' onclick="revelar()">Expandir cadastro⏵</b></h3>
                            <form hidden="true" action="cadastrar.jsp" method="post" id="fCadastro" onsubmit="return verificar(1)">
                                <div class="user-data">
                                    <div class="input-box">
                                        <span class="data">Nome</span>
                                        <input type="text" name="txtNome" id="idNome" placeholder="Insira o seu nome"/>
                                    </div>
                                    <div class="input-box">
                                        <span class="data">CPF</span>
                                        <input type="text" name="txtCPF" id="idCPF" onblur="validaCPF()" placeholder="Insira o seu CPF"/>
                                    </div>
                                    <div class="input-box">
                                        <span class="data">Data de nascimento</span>
                                        <input type="text" name="txtDataNasc" id="idDataNasc" placeholder="Insira a sua data de nascimento"/>
                                    </div>
                                    <div class="input-box">
                                        <span class="data">Cidade</span>
                                        <input type="text" name="txtCidade" id="idCidade" placeholder="Insira a cidade"/>
                                    </div>
                                </div>
                                <div class="button">
                                    <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>
                                </div>
                            </form>
                        </div>
<%
                    }
                    //2.2 Processar o login (executá-lo de fato)
                    else
                    {
                        DAOJPA daoJ = new DAOJPA();
                        String cpf = request.getParameter("txtCPF");
                        
                        //2.2.1 Login de usuário comum (cidadão que quer vacinar-se)
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
                                session.setAttribute("classe", u.getClass());
                                session.setAttribute("login", u);
                                Banco.conexao.close();
%>
                                <h1>Log-in feito com sucesso! Clique <a href="hub.jsp">aqui</a> para continuar</h1>
<%
                            }
                        }
                        //2.2.2 Login de enfermeiro ou gestor
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
                                <h1>Log-in feito com sucesso! Clique <a href="hub.jsp">aqui</a> para continuar</h1>
<%                                      
                            }
                        }
                    }
                }
            }
            //Captura e tratamento de possíveis exceções
            catch(Exception ex)
            {
                Banco.conexao.close();
%>
                <h1>Erro: <%=ex.getMessage()%></h1>
<%
            }
%>
        </div>
    </body>
</html>
