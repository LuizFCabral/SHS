<%--
    create table agenda(
	codigo serial primary key,
	data_agendamento date,
	CONSTRAINT codigo_usuario FOREIGN KEY (codigo) REFERENCES usuario (codigo),
	data_vacinacao date,
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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript" src="javascript/js_geral.js"></script>
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
            
            try 
            {
                bb = new Banco();
                dao = new AgendaJpaController(Banco.conexao);
                SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy"); //Formatador de datas
                SimpleDateFormat tF = new SimpleDateFormat("dd/MM/yyyy hh:mm"); //Formatador geral
                SimpleDateFormat hF = new SimpleDateFormat("hh:mm"); //Formatador de horas
                
                //Obtendo o usuário logado...
                login = new Usuario();
                login = (Usuario)session.getAttribute("login");
                
                //Se alguém estiver logado
                if(login != null) {
                    
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
                                Data de vacinação: <input type="text" name="txtDataVacinacao" id="idDataVacinacao" value="<%=obj.getDataVacinacao()%>"/> <br/>
                                Hora de vacinação: <input type="text" name="txtHoraVacinacao" id="idHoraVacinacao"/> <br/>
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
                                obj = new Agenda();
                                obj = login.getAgenda();
                                if(obj == null) {
                                    obj = new Agenda();
                                    hoje = new Timestamp(System.currentTimeMillis());
                                    obj.setDataAgendamento(hoje);
                                    obj.setUsuario(login);
                                    dataHora = "" + request.getParameter("txtDataVacinacao") + " " + request.getParameter("txtHoraVacinacao");
                                    obj.setDataVacinacao(tF.parse(dataHora));
                                    obj.setDoseNumero(Integer.parseInt(request.getParameter("txtDoseNum")));
                                    dao.create(obj);
%>
                                    <h1>Agendamento concluído com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
<%
                                }
                                else {
                                    throw new Exception("Esse usuário já possui um agendamento");
                                }
                            break;

                            case "Alterar":
                                cod = Integer.parseInt(request.getParameter("txtCod"));
                                obj = dao.findAgenda(cod);
                                if(obj == null)
                                    throw new Exception("Esse agendamento não existe.");

                                obj = new Agenda();
                                obj.setCodigo(Integer.parseInt(request.getParameter("txtCod")));
                                obj.setDataAgendamento(dF.parse(request.getParameter("txtDataAgendamento")));
                                obj.setUsuario(login);
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
%>
                                <h1>Agendamento concluído com sucesso. Código: <%=obj.getCodigo()%></h1>Clique <a href="agenda.jsp">aqui</a> para voltar ao formulário de agendamento
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
                                                <th>Data de agendamento</th>
                                                <th>Código de usuário</th>
                                                <th>Data de vacinação</th>
                                                <th>Número de dose</th>
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
                                                    <td><%=obj.getDataAgendamento()%></td>
                                                    <td><%=obj.getUsuario().getCodigo()%></td>
                                                    <td><%=dF.format(obj.getDataVacinacao())%></td>
                                                    <td><%=obj.getDoseNumero()%></td>
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
                    throw new Exception("Nenhum usuário está logado.");
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