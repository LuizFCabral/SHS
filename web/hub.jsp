<%-- 
HUB ============================================================================
Feito o login, esta é a página que se abrirá e em que se permanecerá. Trata-se do local
onde fica a sidebar (o menuzinho) e um iframe. De acordo com a página/função em 
que se clicar nessa sidebar, tal página se abrirá dentro do hub por meio do iframe 
(o hub não fechará para a nova página abrir, mas esta se abrirá dentro do hub, 
ambas funcionam ao menos tempo, mas uma dentro da outra). Isso ocorre de tal modo que, como 
o nome da página sugere, o hub é a central do sistema. Como dito, após o login, 
não se sairá mais dele.
--%>

<%@page import="model.UsuarioApl"%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SHS</title>
            <link rel="stylesheet" href="estilo/style.css">
            <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
    </head>
    <body>
        <%
            request.setCharacterEncoding("UTF-8");
            String nome, tipo, icone;
            try
            {
                if(session.getAttribute("login") == null)
                    throw new Exception("Faça log-in <a href='index.jsp'>aqui</a>");
        %>
        <div class="sidebar">
            <div class="logo_content">
                <div class="logo_nome">SSD</div>
                <i class='bx bx-menu' id="btn"></i>
            </div>
            <ul class="nav_list">
            <div id="Home">
                <li>
                    <a href="hub.jsp">
                        <i class='bx bxs-home'></i>
                        <span class="nomes_links">Tela inicial</span>
                    </a>
                    <span class="toltip">Início</span>
                </li>
                <br><br><br>
            </div>
            <%
                if(session.getAttribute("classe") == Usuario.class)
                {
                    nome = ((Usuario)session.getAttribute("login")).getNome().trim();
                    tipo = "Usuário";
                    icone = "<i class='bx bx-user'></i>";
                    String[] aux = nome.split(" ");
                    nome = aux[0];
                %>
                    <div id="Usuario">
                        <li>
                            <a href="usuario.jsp" target="interface">
                                <i class='bx bx-user'></i>
                                <span class="nomes_links">Seus dados</span>
                            </a>
                            <span class="toltip">Seus dados</span>
                        </li>
                        <br><br><br>
                    </div>
                    <div id="Agendar">
                        <li>
                            <a href="agenda.jsp" target="interface">
                                <i class='bx bx-calendar'></i>
                                <span class="nomes_links">Agendar vacinação</span>
                            </a>
                            <span class="toltip">Agendar vacinação</span>
                        </li>
                        <br><br><br>
                    </div>
                <%
                }
                else
                {
                    nome = ((UsuarioApl)session.getAttribute("login")).getNome().trim();
                    tipo = "Enfermeiro";
                    icone = "<i class='bx bx-plus-medical' ></i>";
                    String[] aux = nome.split(" ");
                    nome = aux[0];
                %>
                    <div id="GestEnf">
                        <li>
                            <a href="usuarioApl.jsp" target="interface">
                                <i class='bx bx-user-circle'></i>
                                <span class="nomes_links">Gestores/Enfermeiros</span>
                            </a>
                            <span class="toltip" style="width: 165px;">Gestores/Enfermeiros</span>
                        </li>
                        <br><br><br>
                    </div>
                    <div id="Vacina">
                        <li>
                            <a href="vacina.jsp" target="interface">
                                <i class='bx bx-vial'></i>
                                <span class="nomes_links">Vacinas</span>
                            </a>
                            <span class="toltip">Vacinas</span>
                        </li>
                        <br><br><br>
                    </div>
                    <div id="Usuario">
                        <li>
                            <a href="usuario.jsp" target="interface">
                                <i class='bx bx-user'></i>
                                <span class="nomes_links">Usuários comuns</span>
                            </a>
                            <span class="toltip">Usuários</span>
                        </li>
                        <br><br><br>
                    </div>
                    <div id="Agendar">
                        <li>
                            <a href="agenda.jsp" target="interface">
                                <i class='bx bx-calendar'></i>
                                <span class="nomes_links">Agendamentos</span>
                            </a>
                            <span class="toltip">Agendamentos</span>
                        </li>
                        <br><br><br>
                    </div>
                    <div id="Aplicar">
                        <li>
                            <a href="atualizarVacina.jsp" target="interface">
                                <i class='bx bxs-virus-block' ></i>
                                <span class="nomes_links">Aplicação de vacina</span>
                            </a>
                            <span class="toltip">Aplicação</span>
                        </li>
                        <br><br><br>
                    </div>
                <%
                    UsuarioApl obj = (UsuarioApl) session.getAttribute("login");
                    if(obj.getTipoPessoa().equals("G"))
                    {
                        tipo = "Gestor";
                        icone = "<i class='bx bxs-data' ></i>";
                    %>
                        <div id="Movimento">
                            <li>
                                <a href="controleMovimento.jsp" target="interface">
                                    <i class='bx bxs-box'></i>
                                    <span class="nomes_links">Movimentos</span>
                                </a>
                                <span class="toltip">Movimentos</span>
                            </li>
                            <br><br><br>
                        </div>
                        <div id="Relatorio">
                            <li>
                                <a href="relatorio.jsp" target="interface">
                                    <i class='bx bxs-spreadsheet' ></i>
                                    <span class="nomes_links">Relatório</span>
                                </a>
                                <span class="toltip">Relatório</span>
                            </li>
                            <br><br><br>
                        </div>
                    <%
                    }
                }
            %>
                <div id="Exit">
                    <li>
                        <a href="index.jsp?bDeslog=Deslogar">
                            <i class='bx bx-log-out'></i>
                            <span class="nomes_links">Sair</span>
                        </a>
                        <span class="toltip">Sair</span>
                    </li>
                    <br><br><br>
                </div>
            </ul>
            <div class="profile_content">
                <div class="profile">
                    <div class="profile_detail">
                        <%=icone%>
                        <div class="name_type">
                            <div class="name"><%=nome%></div>
                            <div class="type"><%=tipo%></div>
                        </div>
                    </div>
                </div>
            </div>
        </div> 
            <iframe name="interface" src="welcome.html" width="1500" height="620" style="border: 0"></iframe>
            <script>
                let btn = document.querySelector("#btn");
                let sidebar = document.querySelector(".sidebar");

                btn.onclick = function () {
                    sidebar.classList.toggle("active");
                };
            </script><%
            }
            catch(Exception ex)
            {
                %><h1><%=ex.getMessage()%></h1><%
            }
        %>
    </body>
</html>
