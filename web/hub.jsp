<%-- 
    Document   : index
    Created on : 09/09/2021, 11:41:01
    Author     : Vinicius

--%>

<%@page import="model.UsuarioApl"%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SHS</title>
            <script>
            let btn = document.querySelector("#btn");
            let sidebar = document.querySelector(".sidebar");

            btn.onclick = function () {
                sidebar.classList.toggle("active");
            };
        </script>
    </head>
    <body>
        <%
            request.setCharacterEncoding("UTF-8");
            try
            {
                if(session.getAttribute("login") == null)
                    throw new Exception("Faça log-in <a href='index.jsp'>aqui</a>");
        %>
        <div>
            <div class="sidebar">
                <div class="logo_content">
                    <div class="logo_nome">SSD</div>
                    <i class='bx bx-menu' id="btn"></i>
                </div>
                <ul class="nav_list">
                <%
                    if(session.getAttribute("classe") == Usuario.class)
                    {
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
                    %>
                        <div id="GestEnf">
                            <li>
                                <a href="usuarioApl.jsp" target="interface">
                                    <i class='bx bx-user-circle'></i>
                                    <span class="nomes_links">Gestores/Enfermeiros</span>
                                </a>
                                <span class="toltip">Gestores/Enfermeiros</span>
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
                                    <i class='bx bx-calendar'></i>
                                    <span class="nomes_links">Aplicação de vacina</span>
                                </a>
                                <span class="toltip">Aplicação de vacina</span>
                            </li>
                            <br><br><br>
                        </div>
                    <%
                        UsuarioApl obj = (UsuarioApl) session.getAttribute("login");
                        if(obj.getTipoPessoa().equals("G"))
                        {
                        %>
                            <div id="Movimento">
                                <li>
                                    <a href="controleMovimento.jsp" target="interface">
                                        <i class='bx bx-calendar'></i>
                                        <span class="nomes_links">Movimentos</span>
                                    </a>
                                    <span class="toltip">Movimentos</span>
                                </li>
                                <br><br><br>
                            </div>
                            <div id="Relatorio">
                                <li>
                                    <a href="relatorio.jsp" target="interface">
                                        <i class='bx bx-calendar'></i>
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
                </ul>
            </div> 
        </div>
        <div>
            <iframe id="interface"></iframe>
        </div>
        <%
            }
            catch(Exception ex)
            {
                %><h1><%=ex.getMessage()%></h1><%
            }
        %>
    </body>
</html>
