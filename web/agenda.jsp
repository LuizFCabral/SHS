<%--
    create table agenda(
        codigo serial primary key,
        data_agendamento timestamp default current_timestamp,
        codigo_usuario int REFERENCES usuario (codigo),
        data_vacinacao timestamp,
        dose_numero int
    );
--%>

<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.*"%>
<%@page import="controller.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gerenciamento de usuários</title>
        <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
            function mensagem(p, d)
            {
                t = "";
                switch(p)
                {
                    case 1:
                       t = "A vacinação ainda não chegou. Vá ao posto de saúde no dia " + d + " para vacinar-se.";
                       break;
                   case 2:
                       t = "O seu agendamento está atrasado, estava marcado para " + d + ". Vá no posto o quanto antes ou altere o seu agendamento.";
                       break;
                   default:
                       t = "Erro inesperado!";
                       break;
                }
                alert(t);
            }
        </script>
    </head>
    <body>
        <a href="index.jsp">Tela inicial</a>
<%
            request.setCharacterEncoding("UTF-8");
            Agenda obj;
            String b;
            AgendaJpaController dao;
            Banco bb;
            Usuario login;
            UsuarioJpaController daoU;
            try 
            {
                bb = new Banco();
                dao = new AgendaJpaController(Banco.conexao);
                daoU = new UsuarioJpaController(Banco.conexao);
                SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy"); //Formatador de datas
                SimpleDateFormat tF = new SimpleDateFormat("dd/MM/yyyy HH:mm"); //Formatador geral
                SimpleDateFormat hF = new SimpleDateFormat("HH:mm"); //Formatador de horas
                
                //Obtendo o usuário logado...
                login = new Usuario();
                login = (Usuario)session.getAttribute("login");
                //Se alguém estiver logado
                if(login != null) {
                    //atualizando o usuário logado para garantir "frescor" dos dados
                    login = daoU.findUsuario(login.getCodigo());
                    session.setAttribute("login", login);
                    
                    //Sem operações do CRUD a executar...
                    if(request.getParameter("b1") == null)
                    {
                        //Sem dados de tabela a carregar...
                        if(request.getParameter("bCarregar") == null)
                        {
                            //Form para o CRUD...
%>                      
                            <form action="agenda.jsp" method="post" onsubmit="return verificar(1)">
                                Código: <input type="text" name="txtCod" id="idCod"/> <br/>
                                Data de vacinação: <input type="text" name="txtDataVacinacao" id="idDataVacinacao"/> <br/>
                                Hora de vacinação: <input type="text" name="txtHoraVacinacao" id="idHoraVacinacao"/> <br/>
                                Número de dose: <input type="text" name="txtDoseNum" id="idDoseNum"/><br/><br/>
                                <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                            </form>
<%
                        }
                        //Carregando dados da tabela...
                        else
                        {
                            obj = dao.findAgenda(Integer.parseInt(request.getParameter("bCarregar")));
                            //Form com os dados carregados
%>
                            <form action="agenda.jsp" method="post" onsubmit="return verificar(1)">
                                Código: <input type="text" name="txtCod" id="idCod" value="<%=obj.getCodigo()%>"/> <br/>
                                Data de vacinação: <input type="text" name="txtDataVacinacao" id="idDataVacinacao" value="<%=dF.format(obj.getDataVacinacao())%>"/> <br/>
                                Hora de vacinação: <input type="text" name="txtHoraVacinacao" id="idHoraVacinacao" value="<%=hF.format(obj.getDataVacinacao())%>"/> <br/>
                                Número de dose: <input type="text" name="txtDoseNum" id="idDoseNum" value="<%=obj.getDoseNumero()%>"/><br/><br/>
                                <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Alterar" onclick="definir(1)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                            </form>
<%
                        }
                    }
                    //CRUD agenda...
                    else
                    {
                        b = request.getParameter("b1");
                        DAOJPA daoJ = new DAOJPA();
                        int cod;
                        Timestamp hoje; //Pega data e hora do momento do agendamento
                        String dataHora;

                        switch(b)
                        {
                            case "Cadastrar":
                                if(login.getAgendaList().isEmpty()) {
                                    obj = new Agenda();
                                    hoje = new Timestamp(System.currentTimeMillis());
                                    obj.setDataAgendamento(hoje);
                                    obj.setCodigoUsuario(login);
                                    dataHora = "" + request.getParameter("txtDataVacinacao") + " " + request.getParameter("txtHoraVacinacao");
                                    obj.setDataVacinacao(tF.parse(dataHora));
                                    obj.setDoseNumero(Integer.parseInt(request.getParameter("txtDoseNum")));
                                    dao.create(obj);
%>
                                    <h1>Agendamento concluído com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                                }
                                else {
                                    List<Agenda> lista = login.getAgendaList();
                                    for(int i = 0; i < lista.size(); i++)
                                    {
                                        Agenda aux = lista.get(i);
                                        if(aux.getVacinacaoList().isEmpty())
                                        {
                                            hoje = new Timestamp(System.currentTimeMillis());
                                            String t = "Este usuário já possui um agendamento vigente. ";
                                            if(hoje.before(aux.getDataVacinacao()))
                                            {
                                                t += "Vá para o posto de vacinação no dia " + dF.format(aux.getDataVacinacao()) + ", às " + hF.format(aux.getDataVacinacao()) + ".";
                                            }
                                            else
                                            {
                                                t += "Seu agendamento passou do prazo, vacine-se o quanto antes ou altere o seu agendamento.";
                                            }
                                            throw new Exception(t);
                                        }
                                    }
                                    obj = new Agenda();
                                    hoje = new Timestamp(System.currentTimeMillis());
                                    obj.setDataAgendamento(hoje);
                                    obj.setCodigoUsuario(login);
                                    dataHora = "" + request.getParameter("txtDataVacinacao") + " " + request.getParameter("txtHoraVacinacao");
                                    obj.setDataVacinacao(tF.parse(dataHora));
                                    obj.setDoseNumero(Integer.parseInt(request.getParameter("txtDoseNum")));
                                    dao.create(obj);
%>
                                    <h1>Agendamento concluído com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                                    
                                }
                            break;

                            case "Alterar":
                                cod = Integer.parseInt(request.getParameter("txtCod"));
                                obj = dao.findAgenda(cod);
                                if(obj == null)
                                    throw new Exception("Esse agendamento não existe.");

                                hoje = new Timestamp(System.currentTimeMillis());
                                obj.setDataAgendamento(hoje);
                                dataHora = "" + request.getParameter("txtDataVacinacao") + " " + request.getParameter("txtHoraVacinacao");
                                obj.setDataVacinacao(tF.parse(dataHora));
                                obj.setDoseNumero(Integer.parseInt(request.getParameter("txtDoseNum")));
                                dao.edit(obj);
%>
                                <h1>Agendamento alterado com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                            break;

                            case "Remover":
                                cod = Integer.parseInt(request.getParameter("txtCod"));
                                obj = dao.findAgenda(cod);
                                if(obj == null)
                                    throw new Exception("Esse agendamento não existe.");
                                
                                dao.destroy(cod);
                                login = daoU.findUsuario(login.getCodigo());
                                session.setAttribute("login", login);
%>
                                <h1>Agendamento removido com sucesso.</h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                            break;

                            case "Consultar":
                                List<Agenda> lista = dao.findAgendaEntities();
                                if(lista == null || lista.isEmpty())
                                {
                                    throw new Exception("Lista nula ou vazia.");
                                }
                                else
                                {
%>
                                    <h1>Agendamento</h1>
                                    <form action="agenda.jsp" method="post">
                                    <table border="1">
                                        <thead>
                                            <tr>
                                                <th>Código</th>
                                                <th>Data de modificação</th>
                                                <th>Hora de modificação</th>
                                                <th>Código de usuário</th>
                                                <th>Data marcada</th>
                                                <th>Hora marcada</th>
                                                <th>Data da aplicação</th>
                                                <th>Hora da aplicação</th>
                                                <th>Número da dose</th>
                                                <th>Comprovante</th>
                                            </tr>
                                        </thead>
                                        <tbody>
<%
                                            for(int i = 0; i < lista.size(); i++)
                                            {
                                                obj = lista.get(i);
%>
                                                <tr>
                                                    <td><input type="submit" name="bCarregar" value="<%=obj.getCodigo()%>"/></td>
                                                    <td><%=dF.format(obj.getDataAgendamento())%></td>
                                                    <td><%=hF.format(obj.getDataAgendamento())%></td>
                                                    <td><%=obj.getCodigoUsuario().getCodigo()%></td>
                                                    <td><%=dF.format(obj.getDataVacinacao())%></td>
                                                    <td><%=hF.format(obj.getDataVacinacao())%></td>
                                                    <%
                                                        boolean vacinou = false;
                                                        Vacinacao vac = new Vacinacao();
                                                        if(!obj.getVacinacaoList().isEmpty())
                                                        {
                                                            vac = obj.getVacinacaoList().get(0);
                                                            vacinou = true;
                                                            %><td><%=dF.format(vac.getDataAplicacao())%></td>
                                                            <td><%=hF.format(vac.getDataAplicacao())%></td><%
                                                        }
                                                        else
                                                        {
                                                            %><td>--/--/----</td>
                                                            <td>--:--</td><%
                                                        }
                                                    %>
                                                    <td><%=obj.getDoseNumero()%></td>
                                                    <td>
                                                    <%
                                                        if(vacinou)
                                                        { 
                                                            int codVac = vac.getCodigo();
                                                            %><a href="imprimirComprovante.jsp?vacinacao=<%=codVac%>">Acessar</a> <%
                                                        }
                                                        else
                                                        {
                                                            int param = 2; //1 para agendamento futuro e 2 para atrasado
                                                            hoje = new Timestamp(System.currentTimeMillis());
                                                            if(hoje.before(obj.getDataVacinacao()))
                                                                param = 1;
                                                            %>                                                              
                                                            <input type="text" id="p1" value="<%=param%>"> <input type="text" id="p2" value="<%=dF.format(obj.getDataVacinacao()) + ", às " + hF.format(obj.getDataVacinacao())%>"><i id="saibaMais">rejkejw</i>
                                                            <script>
                                                                saibaMais.onclick = function()
                                                                {
                                                                    mensagem($("#p1").val().toString(), $("#p2").val().toString());
                                                                }
                                                            </script><%
                                                        }
                                                    %>
                                                    </td>
                                                </tr>
<%
                                            }
%>
                                            </tbody>
                                        </table>
                                    </form>
                                    Selecione o campo código de um agendamento para carregar seus dados no formulário.<br/>
                                    Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                                }
                            break;

                            default:
                                throw new Exception("Erro inesperado ao ler evento do botão.");
                        }
                        Banco.conexao.close();
                    }
                } 
                else {
                    throw new Exception("Nenhum usuário está logado. <a href='loginUsuario.jsp'>Logar agora</a>");
                }
            }
            catch(Exception ex) {
                Banco.conexao.close();
%>
                <h1>Erro: <%=ex.getMessage()%></h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
            }
%>
    </body>
</html>