<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.*" %>
<%@ page import="org.xu.swan.util.DateUtil" %>

<%
    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");//TODO location_id
    int cd_id = 0;
    ArrayList list_emp = Employee.findAllByLoc(Integer.parseInt(loc));
    String dt = request.getParameter("dt");
    ArrayList list_rec = Reconciliation.findTransByLocDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
    BigDecimal total_amex = new BigDecimal(0.0);
    BigDecimal total_visa = new BigDecimal(0.0);
    BigDecimal total_mastercard = new BigDecimal(0.0);
    BigDecimal total_cheque = new BigDecimal(0.0);
    BigDecimal total_cash = new BigDecimal(0.0);
    BigDecimal total_gift = new BigDecimal(0.0);
    BigDecimal total_amex_ = new BigDecimal(0.0);
    BigDecimal total_visa_ = new BigDecimal(0.0);
    BigDecimal total_mastercard_ = new BigDecimal(0.0);
    BigDecimal total_cheque_ = new BigDecimal(0.0);
    BigDecimal total_gift_ = new BigDecimal(0.0);
    BigDecimal total_cash_ = new BigDecimal(0.0);
    BigDecimal total_card_ = new BigDecimal(0.0);
    BigDecimal total_card = new BigDecimal(0.0);

    BigDecimal total_payin = new BigDecimal(0.0);
    BigDecimal total_payout = new BigDecimal(0.0);

    int pennies = 0;
    int nickels = 0;
    int dimes = 0;
    int quarters = 0;
    int half_dollars = 0;
    int dollars = 0;
    int singles = 0;
    int fives = 0;
    int tens = 0;
    int twenties = 0;
    int fifties = 0;
    int hundreds = 0;
    BigDecimal pennies_amnt = new BigDecimal(0.0);
    BigDecimal nickels_amnt = new BigDecimal(0.0);
    BigDecimal dimes_amnt = new BigDecimal(0.0);
    BigDecimal quarters_amnt = new BigDecimal(0.0);
    BigDecimal half_dollars_amnt = new BigDecimal(0.0);
    BigDecimal dollars_amnt = new BigDecimal(0.0);
    BigDecimal singles_amnt = new BigDecimal(0.0);
    BigDecimal fives_amnt = new BigDecimal(0.0);
    BigDecimal tens_amnt = new BigDecimal(0.0);
    BigDecimal twenties_amnt = new BigDecimal(0.0);
    BigDecimal fifties_amnt = new BigDecimal(0.0);
    BigDecimal hundreds_amnt = new BigDecimal(0.0);
    BigDecimal total_amnt = new BigDecimal(0.0);
    BigDecimal cheque_over = new BigDecimal(0.0);
    BigDecimal cash_over = new BigDecimal(0.0);
    BigDecimal gift_over = new BigDecimal(0.0);
    BigDecimal cheque_short = new BigDecimal(0.0);
    BigDecimal cash_short = new BigDecimal(0.0);
    BigDecimal gift_short = new BigDecimal(0.0);
    BigDecimal creditcard = new BigDecimal(0.0);
    BigDecimal creditcard_over = new BigDecimal(0.0);
    BigDecimal creditcard_short = new BigDecimal(0.0);

    CashDrawing cd_open = CashDrawing.findByDateStatus(Integer.parseInt(loc), DateUtil.parseSqlDate(dt), 0);
    BigDecimal startingDay = new BigDecimal(0);
    startingDay = startingDay.add(new BigDecimal(cd_open.getPennies()).divide(new BigDecimal(100))).add(new BigDecimal(cd_open.getNickels()).divide(new BigDecimal(20))).add(new BigDecimal(cd_open.getDimes()).divide(new BigDecimal(10))).add(new BigDecimal(cd_open.getQuarters()).divide(new BigDecimal(4))).add(new BigDecimal(cd_open.getHalf_dollars()).divide(new BigDecimal(2))).add(new BigDecimal(cd_open.getDollars())).add(new BigDecimal(cd_open.getSingles())).add(new BigDecimal(cd_open.getFives()).multiply(new BigDecimal(5))).add(new BigDecimal(cd_open.getTens()).multiply(new BigDecimal(10))).add(new BigDecimal(cd_open.getTwenties()).multiply(new BigDecimal(20))).add(new BigDecimal(cd_open.getFifties()).multiply(new BigDecimal(50))).add(new BigDecimal(cd_open.getHundreds()).multiply(new BigDecimal(100)));

    CashDrawing cd = CashDrawing.findByDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
    if (cd != null && cd.getOpenClose() != 0){
        pennies_amnt = new BigDecimal(cd.getPennies()).divide(new BigDecimal(100));
        nickels_amnt = new BigDecimal(cd.getNickels()).divide(new BigDecimal(20));
        dimes_amnt = new BigDecimal(cd.getDimes()).divide(new BigDecimal(10));
        quarters_amnt = new BigDecimal(cd.getQuarters()).divide(new BigDecimal(4));
        half_dollars_amnt = new BigDecimal(cd.getHalf_dollars()).divide(new BigDecimal(2));
        dollars_amnt = new BigDecimal(cd.getDollars());
        singles_amnt = new BigDecimal(cd.getSingles());
        fives_amnt = new BigDecimal(cd.getFives()).multiply(new BigDecimal(5));
        tens_amnt = new BigDecimal(cd.getTens()).multiply(new BigDecimal(10));
        twenties_amnt = new BigDecimal(cd.getTwenties()).multiply(new BigDecimal(20));
        fifties_amnt = new BigDecimal(cd.getFifties()).multiply(new BigDecimal(50));
        hundreds_amnt = new BigDecimal(cd.getHundreds()).multiply(new BigDecimal(100));
        total_amnt = total_amnt.add(new BigDecimal(cd.getPennies()).divide(new BigDecimal(100))).add(new BigDecimal(cd.getNickels()).divide(new BigDecimal(20))).add(new BigDecimal(cd.getDimes()).divide(new BigDecimal(10))).add(new BigDecimal(cd.getQuarters()).divide(new BigDecimal(4))).add(new BigDecimal(cd.getHalf_dollars()).divide(new BigDecimal(2))).add(new BigDecimal(cd.getDollars())).add(new BigDecimal(cd.getSingles())).add(new BigDecimal(cd.getFives()).multiply(new BigDecimal(5))).add(new BigDecimal(cd.getTens()).multiply(new BigDecimal(10))).add(new BigDecimal(cd.getTwenties()).multiply(new BigDecimal(20))).add(new BigDecimal(cd.getFifties()).multiply(new BigDecimal(50))).add(new BigDecimal(cd.getHundreds()).multiply(new BigDecimal(100)));
        pennies = cd.getPennies();
        nickels = cd.getNickels();
        dimes = cd.getDimes();
        quarters = cd.getQuarters();
        half_dollars = cd.getHalf_dollars();
        dollars = cd.getDollars();
        singles = cd.getSingles();
        fives = cd.getFives();
        tens = cd.getTens();
        twenties = cd.getTwenties();
        fifties = cd.getFifties();
        hundreds = cd.getHundreds();
        cd_id = cd.getId();
        total_amex_ = cd.getAmex();
        total_visa_ = cd.getVisa();
        total_mastercard_ = cd.getMastercard();
        total_card_ = total_amex_.add(total_visa_).add(total_mastercard_);
        total_cheque_ = cd.getCheque();
        total_cash_ = cd.getCash();
        total_gift_ = cd.getGift();
        creditcard_over = cd.getCard_over();
        cheque_over = cd.getCheque_over();
        cash_over = cd.getCash_over();
        gift_over = cd.getGift_over();
        creditcard_short = cd.getCard_short();
        cheque_short = cd.getCheque_short();
        cash_short = cd.getCash_short();
        gift_short = cd.getGift_short();
        creditcard = cd.getCreditcard();
    }

    for (int i = 0; i < list_rec.size(); i++) {
        Reconciliation tran = (Reconciliation) list_rec.get(i);
        String trans_code = tran.getCode_transaction();

        BigDecimal amex = tran.getAmex();
        BigDecimal visa = tran.getVisa();
        BigDecimal mastercard = tran.getMastercard();
        BigDecimal creditcard_ = tran.getMastercard();
        BigDecimal cheque = tran.getCheque();
        BigDecimal giftcard = tran.getGiftcard();
        BigDecimal cash = tran.getCashe();
        BigDecimal change = tran.getChange();

       if(tran.getStatus() == 5)
          total_payin = total_payin.add(tran.getTotal());
        else
            if(tran.getStatus() == 3)
                total_payout = total_payout.add(tran.getTotal());

        if ((tran.getStatus() != 6) && (tran.getStatus() != 2))
        {
            if ((tran.getStatus() == 3) || (tran.getStatus() == 4)) {
                total_cash = total_cash.subtract(cash);
                total_cheque = total_cheque.subtract(cheque);
                total_gift = total_gift.subtract(giftcard);
                total_amex = total_amex.subtract(amex);
                total_mastercard = total_mastercard.subtract(mastercard);
                total_visa = total_visa.subtract(visa);
                total_card = total_visa.add(total_amex).add(total_mastercard);
            } else{
                total_cash = total_cash.add(cash).subtract(change);
                total_cheque = total_cheque.add(cheque);
                total_gift = total_gift.add(giftcard);
                total_amex = total_amex.add(amex);
                total_mastercard = total_mastercard.add(mastercard);
                total_visa = total_visa.add(visa);
                total_card = total_visa.add(total_amex).add(total_mastercard);
            }
        }
    }
%>
<div align="center">
<div style="width: 696px; height: 550px; background: url(img/cc_bg.png)">
<br />
<table id="Table_01" width="634" height="475" border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td colspan="2" align="center">
			<!--img src="img/cc_01.png" width="103" height="45" alt=""-->
              <%
                  Date _d = new Date(request.getParameter("dt"));
                  Date d = Calendar.getInstance().getTime();
                  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                  String date = sdf.format(_d);
                  String time = Integer.toString(d.getHours()+1) + ":" + (d.getMinutes() < 10 ? "0" : "") + Integer.toString(d.getMinutes());
              %>
              <%=date+"<br />" + time%>
              <input type="hidden" name="CashDrawingDate" id="CashDrawingDate" value="<%=date + " " + time+":00"%>">
              <input type="hidden" name="cashDrawing_id" id="cashDrawing_id" value="<%=cd_id%>">
              <input type="hidden" name="total_card" id="total_card" value="<%=total_card%>">
              <input type="hidden" name="total_cash" id="total_cash" value="<%=total_cash%>">
              <input type="hidden" name="total_check" id="total_check" value="<%=total_cheque%>">
              <input type="hidden" name="total_gift" id="total_gift" value="<%=total_gift%>">
        </td>
		<td colspan="10">
			<img src="img/cc_02.png" width="482" height="45" alt=""></td>
		<td>
			<a href="#" onclick="Modalbox.hide();"><img src="img/cc_03.png" width="48" height="45" alt="" border=0/></a>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="45" alt=""></td>
	</tr>
	<tr>
		<td colspan="13">
			<img src="img/cc_04.png" width="633" height="28" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="28" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/cc_05.png" width="81" height="31" alt=""></td>
		<td colspan="3">
			<!--img src="img/cc_06.png" width="47" height="31" alt=""-->
			<input type="text" onchange="calcAmount('pennies')" name="pennies_qty" id="pennies_qty" value="<%=pennies%>" style="background: url(img/cc_06.png); width: 47px; height: 31px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<!--img src="img/cc_07.png" width="90" height="31" alt=""-->
			<input type="text"  onchange="calcQty('pennies')" name="pennies_amount" id="pennies_amount"  value="<%=pennies_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_07.png); width: 90px; height: 31px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/cc_08.png" width="146" height="31" alt=""></td>
		<td>
			<!--img src="img/cc_09.png" width="89" height="31" alt=""-->
			<input type="text" id="opening_cash" name="opening_cash" value="<%=startingDay.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" onchange="totalCalc('cash');" type="text" readonly style="background: url(img/cc_09.png); width: 89px; height: 31px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td colspan="6">
			<img src="img/cc_10.png" width="180" height="31" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="31" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/cc_11.png" width="81" height="30" alt=""></td>
		<td colspan="3">
			<!--img src="img/cc_12.png" width="47" height="30" alt=""-->
			<input type="text" onchange="calcAmount('nickels')" name="nickels_qty" id="nickels_qty"  value="<%=nickels%>" style="background: url(img/cc_12.png); width: 47px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<!--img src="img/cc_13.png" width="90" height="30" alt=""-->
			<input type="text"  onchange="calcQty('nickels')" name="nickels_amount" id="nickels_amount"  value="<%=nickels_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_13.png); width: 90px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td colspan="8" rowspan="3">
			<img src="img/cc_14.png" width="415" height="66" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="30" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/cc_15.png" width="81" height="30" alt=""></td>
		<td colspan="3">
			<!--img src="img/cc_16.png" width="47" height="30" alt=""-->
			<input type="text" onchange="calcAmount('dimes')" name="dimes_qty" id="dimes_qty"  value="<%=dimes%>" style="background: url(img/cc_16.png); width: 47px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<!--img src="img/cc_17.png" width="90" height="30" alt=""-->
			<input type="text" onchange="calcQty('dimes')" name="dimes_amount" id="dimes_amount"  value="<%=dimes_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_17.png); width: 90px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="30" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_18.png" width="81" height="30" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/cc_19.png" width="47" height="30" alt=""-->
			<input type="text"  onchange="calcAmount('quarters')" name="quarters_qty" id="quarters_qty"  value="<%=quarters%>" style="background: url(img/cc_19.png); width: 47px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<!--img src="img/cc_20.png" width="90" height="30" alt=""-->
			<input type="text" onchange="calcQty('quarters')" name="quarters_amount" id="quarters_amount"  value="<%=quarters_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_20.png); width: 90px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="6" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_21.png" width="146" height="28" alt=""></td>
		<td rowspan="2">
			<!--img src="img/cc_22.png" width="89" height="28" alt=""-->
			<input name="creditcard" id="creditcard" value="<%=((cd!=null)?creditcard.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_card.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>" onchange="totalCalc('creditcard');" type="text" style="background: url(img/cc_22.png); width: 89px; height: 28px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/cc_23.png" width="47" height="28" alt=""></td>
		<td rowspan="2">
			<!--img src="img/cc_24.png" width="63" height="28" alt=""-->
			<input name="creditcard_over" id="creditcard_over" value="<%=creditcard_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text" style="background: url(img/cc_24.png); width: 63px; height: 28px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<img src="img/cc_25.png" width="7" height="28" alt=""></td>
		<td colspan="2" rowspan="2">
			<!--img src="img/cc_26.png" width="63" height="28" alt=""-->
			<input name="creditcard_short" id="creditcard_short" value="<%=creditcard_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text" style="background: url(img/cc_26.png); width: 63px; height: 28px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="24" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_27.png" width="81" height="30" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/cc_28.png" width="47" height="30" alt=""-->
			<input type="text" onchange="calcAmount('half_dollars')" name="half_dollars_qty" id="half_dollars_qty"  value="<%=half_dollars%>"   style="background: url(img/cc_28.png); width: 47px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<!--img src="img/cc_29.png" width="90" height="30" alt=""-->
			<input type="text" onchange="calcQty('half_dollars')" name="half_dollars_amount" id="half_dollars_amount"  value="<%=half_dollars_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_29.png); width: 90px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="4" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_30.png" width="146" height="30" alt=""></td>
		<td rowspan="2">
			<!--img src="img/cc_31.png" width="89" height="30" alt=""-->
			<input type="text" id="cash_amount" name="cash_amount" value="<%=((cd!=null)?total_cash_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_cash.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>" onchange="totalCalc('cash');" style="background: url(img/cc_31.png); width: 89px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/cc_32.png" width="47" height="30" alt=""></td>
		<td rowspan="2">
			<!--img src="img/cc_33.png" width="63" height="30" alt=""-->
			<input readonly id="cash_over" name="cash_over" value="<%=cash_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text" style="background: url(img/cc_33.png); width: 63px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<img src="img/cc_34.png" width="7" height="30" alt=""></td>
		<td colspan="2" rowspan="2">
			<!--img src="img/cc_35.png" width="63" height="30" alt=""-->
			<input id="cash_short" name="cash_short" value="<%=cash_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" readonly type="text" style="background: url(img/cc_35.png); width: 63px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="26" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_36.png" width="81" height="30" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/cc_37.png" width="47" height="30" alt=""-->
			<input type="text" onchange="calcAmount('dollars')" name="dollars_qty" id="dollars_qty"  value="<%=dollars%>" style="background: url(img/cc_37.png); width: 47px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<!--img src="img/cc_38.png" width="90" height="30" alt=""-->
			<input type="text" onchange="calcQty('dollars')" name="dollars_amount" id="dollars_amount"  value="<%=dollars_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_38.png); width: 90px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="4" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_39.png" width="146" height="31" alt=""></td>
		<td rowspan="2">
			<!--img src="img/cc_40.png" width="89" height="31" alt=""-->
			<input type="text" id="check_amount" name="check_amount" value="<%=((cd==null)?total_cheque_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_cheque.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>" onchange="totalCalc('check');" style="background: url(img/cc_40.png); width: 89px; height: 31px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/cc_41.png" width="47" height="31" alt=""></td>
		<td rowspan="2">
			<!--img src="img/cc_42.png" width="63" height="31" alt=""-->
			<input id="check_over" name="check_over" value="<%=cheque_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text" style="background: url(img/cc_42.png); width: 63px; height: 31px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<img src="img/cc_43.png" width="7" height="31" alt=""></td>
		<td colspan="2" rowspan="2">
			<!--img src="img/cc_44.png" width="63" height="31" alt=""-->
			<input id="check_short" name="check_short" value="<%=cheque_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text" style="background: url(img/cc_44.png); width: 63px; height: 31px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="26" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_45.png" width="81" height="30" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/cc_46.png" width="47" height="30" alt=""-->
			<input  onchange="calcAmount('singles')" name="singles_qty" id="singles_qty"  value="<%=singles%>" type="text" style="background: url(img/cc_46.png); width: 47px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<!--img src="img/cc_47.png" width="90" height="30" alt=""-->
			<input type="text" onchange="calcQty('singles')" name="singles_amount" id="singles_amount"  value="<%=singles_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_47.png); width: 90px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="5" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_48.png" width="146" height="29" alt=""></td>
		<td rowspan="2">
			<!--img src="img/cc_49.png" width="89" height="29" alt=""-->
			<input type="text" id="gift_amount" name="gift_amount" value="<%=((cd==null)?total_gift_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_gift.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>" onchange="totalCalc('gift');" style="background: url(img/cc_49.png); width: 89px; height: 29px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/cc_50.png" width="47" height="29" alt=""></td>
		<td rowspan="2">
			<!--img src="img/cc_51.png" width="63" height="29" alt=""-->
			<input type="text" id="gift_over" name="gift_over" value="<%=gift_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_51.png); width: 63px; height: 29px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<img src="img/cc_52.png" width="7" height="29" alt=""></td>
		<td colspan="2" rowspan="2">
			<!--img src="img/cc_53.png" width="63" height="29" alt=""-->
			<input type="text" id="gift_short" name="gift_short" value="<%=gift_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_53.png); width: 63px; height: 29px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="25" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_54.png" width="81" height="31" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/cc_55.png" width="47" height="31" alt=""-->
			<input type="text" onchange="calcAmount('fives')" name="fives_qty" id="fives_qty" value="<%=fives%>" style="background: url(img/cc_55.png); width: 47px; height: 31px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<!--img src="img/cc_56.png" width="90" height="31" alt=""-->
			<input type="text" onchange="calcQty('fives')" name="fives_amount" id="fives_amount" value="<%=fives_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
             style="background: url(img/cc_56.png); width: 90px; height: 31px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="4" alt=""></td>
	</tr>
	<tr>
		<td colspan="8" rowspan="2">
			<img src="img/cc_57.png" width="415" height="31" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="27" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_58.png" width="81" height="30" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/cc_59.png" width="47" height="30" alt=""-->
			<input type="text" onchange="calcAmount('tens')" name="tens_qty" id="tens_qty"  value="<%=tens%>" style="background: url(img/cc_59.png); width: 47px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<!--img src="img/cc_60.png" width="90" height="30" alt=""-->
			<input type="text" onchange="calcQty('tens')" name="tens_amount" id="tens_amount"  value="<%=tens_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
             style="background: url(img/cc_60.png); width: 90px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="4" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_61.png" width="146" height="30" alt=""></td>
		<td rowspan="2">
			<!--img src="img/cc_62.png" width="89" height="30" alt=""-->
			<input type="text" id="payin" value="<%=total_payin.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_62.png); width: 89px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td colspan="6" rowspan="4">
			<img src="img/cc_63.png" width="180" height="62" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="26" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_64.png" width="81" height="30" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/cc_65.png" width="47" height="30" alt=""-->
			<input type="text" onchange="calcAmount('twenties')" name="twenties_qty" id="twenties_qty"  value="<%=twenties%>" style="background: url(img/cc_65.png); width: 47px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<!--img src="img/cc_66.png" width="90" height="30" alt=""-->
			<input type="text" onchange="calcQty('twenties')" name="twenties_amount" id="twenties_amount"  value="<%=twenties_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_66.png); width: 90px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="4" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_67.png" width="146" height="32" alt=""></td>
		<td rowspan="2">
			<!--img src="img/cc_68.png" width="89" height="32" alt=""-->
			<input type="text" id="payout" value="<%=total_payout.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_68.png); width: 89px; height: 32px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="26" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/cc_69.png" width="81" height="30" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/cc_70.png" width="47" height="30" alt=""-->
			<input type="text" onchange="calcAmount('fifties')" name="fifties_qty" id="fifties_qty"  value="<%=fifties%>" style="background: url(img/cc_70.png); width: 47px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td rowspan="2">
			<!--img src="img/cc_71.png" width="90" height="30" alt=""-->
			<input type="text" onchange="calcQty('fifties')" name="fifties_amount" id="fifties_amount"  value="<%=fifties_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_71.png); width: 90px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="6" alt=""></td>
	</tr>
	<tr>
		<td colspan="8" rowspan="3">
			<img src="img/cc_72.png" width="415" height="64" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="24" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/cc_73.png" width="81" height="30" alt=""></td>
		<td colspan="3">
			<!--img src="img/cc_74.png" width="47" height="30" alt=""-->
			<input type="text" onchange="calcAmount('hundreds')" name="hundreds_qty" id="hundreds_qty"  value="<%=hundreds%>" style="background: url(img/cc_74.png); width: 47px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<!--img src="img/cc_75.png" width="90" height="30" alt=""-->
			<input type="text" onchange="calcQty('hundreds')" name="hundreds_amount" id="hundreds_amount"  value="<%=hundreds_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/cc_75.png); width: 90px; height: 30px; border: 0; padding: 7px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="30" alt=""></td>
	</tr>
	<tr>
		<td colspan="3" rowspan="2">
			<img src="img/cc_76.png" width="121" height="39" alt=""></td>
		<td colspan="2" rowspan="2">
			<!--img src="img/cc_77.png" width="97" height="39" alt=""-->
			<input type="text" id="total" value="<%=total_amnt%>"
             style="background: url(img/cc_77.png); width: 97px; height: 39px; border: 0; padding: 10px 7px 0 7px" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="10" alt=""></td>
	</tr>
	<tr>
		<td colspan="3">
			<img src="img/cc_78.png" width="271" height="29" alt=""></td>
		<td colspan="5">
			<!--img src="img/cc_79.png" width="144" height="29" alt=""-->
			<input type="image" onclick="saveCashDrawing(1);" src="img/cc_79.png" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="29" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/spacer.gif" width="81" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="22" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="18" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="7" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="90" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="146" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="89" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="36" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="11" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="63" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="7" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="15" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="48" height="1" alt=""></td>
		<td></td>
	</tr>
</table>
</div>
</div>
<%--

<div style="background: url(img/close_cash_bg.png); width: 496px; height: 418px;text-align: center">
<br />
<table id="Table_01" width="417" height="353" border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td colspan="2" style="color: #FFF; font-size: 10pt" align=center>
              <%
                  Date _d = new Date(request.getParameter("dt"));
                  Date d = new Date();
                  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                  String date = sdf.format(_d);
                  String time = Integer.toString(d.getHours()+1) + ":" + (d.getMinutes() < 10 ? "0" : "") + Integer.toString(d.getMinutes());
              %>
              <%=date+"<br />" + time%>
              <input type="hidden" name="CashDrawingDate" id="CashDrawingDate" value="<%=date + " " + time+":00"%>">
              <input type="hidden" name="cashDrawing_id" id="cashDrawing_id" value="<%=cd_id%>">
        </td>
		<td colspan="9">
			<img src="img/close_cash_02.png" width="307" height="25" alt=""></td>
		<td>
			<a href="#"><img src="img/close_cash_03.png" width="34" height="25" onclick="Modalbox.hide();" alt="" border="0"></a></td>
		<td>
			<img src="img/spacer.gif" width="1" height="25" alt=""></td>
	</tr>
	<tr>
		<td colspan="12">
			<img src="img/close_cash_04.png" width="416" height="22" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="22" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/close_cash_05.png" width="57" height="20" alt=""></td>
		<td colspan="3">
			<!--img src="img/close_cash_06.png" width="29" height="20" alt=""-->
			<input type="text" onchange="calcAmount('pennies')" name="pennies_qty" id="pennies_qty" value="<%=pennies%>"
            style="width: 29px; height: 20px; background: url(img/close_cash_06.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<!--img src="img/close_cash_07.png" width="60" height="20" alt=""-->
	        <input type="text" onchange="calcQty('pennies')" name="pennies_amount" id="pennies_amount"  value="<%=pennies_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 20px; background: url(img/close_cash_07.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/close_cash_08.png" width="93" height="20" alt=""></td>
		<td>
			<!--img src="img/close_cash_09.png" width="59" height="20" alt=""-->
			<input id="opening_cash" name="opening_cash" value="<%=startingDay.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" onchange="totalCalc('cash');" type="text"
            style="width: 59px; height: 20px; background: url(img/close_cash_09.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="5">
			<img src="img/close_cash_10.png" width="118" height="20" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="20" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/close_cash_11.png" width="57" height="20" alt=""></td>
		<td colspan="3">
			<!--img src="img/close_cash_12.png" width="29" height="20" alt=""-->
			<input type="text" onchange="calcAmount('nickels')" name="nickels_qty" id="nickels_qty"  value="<%=nickels%>"
            style="width: 29px; height: 20px; background: url(img/close_cash_12.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<!--img src="img/close_cash_13.png" width="60" height="20" alt=""-->
			<input type="text" onchange="calcQty('nickels')" name="nickels_amount" id="nickels_amount"  value="<%=nickels_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 20px; background: url(img/close_cash_13.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="7" rowspan="2">
			<img src="img/close_cash_14.png" width="270" height="33" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="20" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_15.png" width="57" height="19" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/close_cash_16.png" width="29" height="19" alt=""-->
			<input type="text" onchange="calcAmount('dimes')" name="dimes_qty" id="dimes_qty"  value="<%=dimes%>"
            style="width: 29px; height: 19px; background: url(img/close_cash_16.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td rowspan="2">
			<!--img src="img/close_cash_17.png" width="60" height="19" alt=""-->
			<input type="text" onchange="calcQty('dimes')" name="dimes_amount" id="dimes_amount"  value="<%=dimes_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 19px; background: url(img/close_cash_17.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="13" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_18.png" width="93" height="20" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_19.png" width="59" height="20" alt=""-->
			<input id="visa_amount" name="visa_amount" value="<%=((cd==null)?total_visa_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_visa.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>" onchange="totalCalc('card');" type="text"
            style="width: 59px; height: 20px; background: url(img/close_cash_19.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/close_cash_20.png" width="29" height="20" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_21.png" width="43" height="20" alt=""-->
			<input type="text" style="width: 43px; height: 20px; background: url(img/close_cash_21.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<!--img src="img/close_cash_22.png" width="46" height="20" alt=""-->
			<input type="text" style="width: 46px; height: 20px; background: url(img/close_cash_22.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="6" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_23.png" width="57" height="19" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/close_cash_24.png" width="29" height="19" alt=""-->
			<input type="text" onchange="calcAmount('quarters')" name="quarters_qty" id="quarters_qty"  value="<%=quarters%>"
            style="width: 29px; height: 19px; background: url(img/close_cash_24.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td rowspan="2">
			<!--img src="img/close_cash_25.png" width="60" height="19" alt=""-->
			<input type="text" onchange="calcQty('quarters')" name="quarters_amount" id="quarters_amount"  value="<%=quarters_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 19px; background: url(img/close_cash_25.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="14" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_26.png" width="93" height="19" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_27.png" width="59" height="19" alt=""-->
			<input id="mastercard_amount" name="mastercard_amount" value="<%=((cd==null)?total_mastercard_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_mastercard.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>" onchange="totalCalc('card');" type="text"
            style="width: 59px; height: 19px; background: url(img/close_cash_27.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/close_cash_28.png" width="29" height="19" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_29.png" width="43" height="19" alt=""-->
			<input type="text" style="width: 43px; height: 19px; background: url(img/close_cash_29.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<!--img src="img/close_cash_30.png" width="46" height="19" alt=""-->
			<input type="text" style="width: 46px; height: 19px; background: url(img/close_cash_30.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="5" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_31.png" width="57" height="20" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/close_cash_32.png" width="29" height="20" alt=""-->
			<input type="text" onchange="calcAmount('half_dollars')" name="half_dollars_qty" id="half_dollars_qty"  value="<%=half_dollars%>"
            style="width: 29px; height: 20px; background: url(img/close_cash_32.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td rowspan="2">
			<!--img src="img/close_cash_33.png" width="60" height="20" alt=""-->
			<input type="text" onchange="calcQty('half_dollars')" name="half_dollars_amount" id="half_dollars_amount"  value="<%=half_dollars_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 20px; background: url(img/close_cash_33.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="14" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_34.png" width="93" height="19" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_35.png" width="59" height="19" alt=""-->
			<input id="amex_amount" name="amex_amount" value="<%=((cd==null)?total_amex_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_amex.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>" onchange="totalCalc('card');" type="text"
            style="width: 59px; height: 19px; background: url(img/close_cash_35.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/close_cash_36.png" width="29" height="19" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_37.png" width="43" height="19" alt=""-->
			<input type="text" style="width: 43px; height: 19px; background: url(img/close_cash_37.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<!--img src="img/close_cash_38.png" width="46" height="19" alt=""-->
			<input type="text" style="width: 46px; height: 19px; background: url(img/close_cash_38.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="6" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_39.png" width="57" height="19" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/close_cash_40.png" width="29" height="19" alt=""-->
			<input type="text" onchange="calcAmount('dollars')" name="dollars_qty" id="dollars_qty"  value="<%=dollars%>"
            style="width: 29px; height: 19px; background: url(img/close_cash_40.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td rowspan="2">
			<!--img src="img/close_cash_41.png" width="60" height="19" alt=""-->
			<input type="text" onchange="calcQty('dollars')" name="dollars_amount" id="dollars_amount"  value="<%=dollars_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 19px; background: url(img/close_cash_41.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="13" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_42.png" width="93" height="19" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_43.png" width="59" height="19" alt=""-->
			<input id="cash_amount" name="cash_amount" value="<%=((cd==null)?total_cash_.setScale(2,BigDecimal.ROUND_HALF_DOWN):new BigDecimal(0))%>" onchange="totalCalc('cash');" type="text"
            style="width: 59px; height: 19px; background: url(img/close_cash_43.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/close_cash_44.png" width="29" height="19" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_45.png" width="43" height="19" alt=""-->
			<input id="cash_over" name="cash_over" value="<%=cash_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text" 
            style="width: 43px; height: 19px; background: url(img/close_cash_45.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<!--img src="img/close_cash_46.png" width="46" height="19" alt=""-->
			<input id="cash_short" name="cash_short" value="<%=cash_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text" 
            style="width: 46px; height: 19px; background: url(img/close_cash_46.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="6" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_47.png" width="57" height="20" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/close_cash_48.png" width="29" height="20" alt=""-->
			<input type="text" onchange="calcAmount('singles')" name="singles_qty" id="singles_qty"  value="<%=singles%>"
            style="width: 29px; height: 20px; background: url(img/close_cash_48.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td rowspan="2">
			<!--img src="img/close_cash_49.png" width="60" height="20" alt=""-->
			<input type="text" onchange="calcQty('singles')" name="singles_amount" id="singles_amount"  value="<%=singles_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 20px; background: url(img/close_cash_49.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="13" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_50.png" width="93" height="20" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_51.png" width="59" height="20" alt=""-->
			<input id="check_amount" name="check_amount" value="<%=((cd==null)?total_cheque_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_cheque.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>" onchange="totalCalc('check');" type="text"
            style="width: 59px; height: 20px; background: url(img/close_cash_51.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/close_cash_52.png" width="29" height="20" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_53.png" width="43" height="20" alt=""-->
			<input id="check_over" name="check_over" value="<%=cheque_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text" 
            style="width: 43px; height: 20px; background: url(img/close_cash_53.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<!--img src="img/close_cash_54.png" width="46" height="20" alt=""-->
			<input id="check_short" name="check_short" value="<%=cheque_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text"
            style="width: 46px; height: 20px; background: url(img/close_cash_54.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="7" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_55.png" width="57" height="19" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/close_cash_56.png" width="29" height="19" alt=""-->
			<input type="text" onchange="calcAmount('fives')" name="fives_qty" id="fives_qty" value="<%=fives%>"
            style="width: 29px; height: 19px; background: url(img/close_cash_56.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td rowspan="2">
			<!--img src="img/close_cash_57.png" width="60" height="19" alt=""-->
			<input type="text" onchange="calcQty('fives')" name="fives_amount" id="fives_amount" value="<%=fives_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 19px; background: url(img/close_cash_57.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="13" alt=""></td>
	</tr>
	<tr>
		<td colspan="7" rowspan="3">
			<img src="img/close_cash_58.png" width="270" height="30" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="6" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/close_cash_59.png" width="57" height="20" alt=""></td>
		<td colspan="3">
			<!--img src="img/close_cash_60.png" width="29" height="20" alt=""-->
			<input type="text" onchange="calcAmount('tens')" name="tens_qty" id="tens_qty"  value="<%=tens%>"
            style="width: 29px; height: 20px; background: url(img/close_cash_60.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<!--img src="img/close_cash_61.png" width="60" height="20" alt=""-->
			<input type="text" onchange="calcQty('tens')" name="tens_amount" id="tens_amount"  value="<%=tens_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 20px; background: url(img/close_cash_61.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="20" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_62.png" width="57" height="19" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/close_cash_63.png" width="29" height="19" alt=""-->
			<input type="text" onchange="calcAmount('twenties')" name="twenties_qty" id="twenties_qty"  value="<%=twenties%>"
            style="width: 29px; height: 19px; background: url(img/close_cash_63.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td rowspan="2">
			<!--img src="img/close_cash_64.png" width="60" height="19" alt=""-->
			<input type="text" onchange="calcQty('twenties')" name="twenties_amount" id="twenties_amount"  value="<%=twenties_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 19px; background: url(img/close_cash_64.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="4" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_65.png" width="93" height="19" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_66.png" width="59" height="19" alt=""-->
			<input id="gift_amount" name="gift_amount" value="<%=((cd==null)?total_gift_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_gift.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>" onchange="totalCalc('gift');" type="text"
            style="width: 59px; height: 19px; background: url(img/close_cash_66.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/close_cash_67.png" width="29" height="19" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_68.png" width="43" height="19" alt=""-->
			<input id="gift_over" name="gift_over" value="<%=gift_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text" 
            style="width: 43px; height: 19px; background: url(img/close_cash_68.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<!--img src="img/close_cash_69.png" width="46" height="19" alt=""-->
			<input id="gift_short" name="gift_short" value="<%=gift_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" type="text" 
            style="width: 46px; height: 19px; background: url(img/close_cash_69.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="15" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_70.png" width="57" height="20" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/close_cash_71.png" width="29" height="20" alt=""-->
			<input type="text" onchange="calcAmount('fifties')" name="fifties_qty" id="fifties_qty"  value="<%=fifties%>"
            style="width: 29px; height: 20px; background: url(img/close_cash_71.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td rowspan="2">
			<!--img src="img/close_cash_72.png" width="60" height="20" alt=""-->
			<input type="text" onchange="calcQty('fifties')" name="fifties_amount" id="fifties_amount"  value="<%=fifties_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 20px; background: url(img/close_cash_72.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="4" alt=""></td>
	</tr>
	<tr>
		<td colspan="7" rowspan="2">
			<img src="img/close_cash_73.png" width="270" height="19" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="16" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_74.png" width="57" height="19" alt=""></td>
		<td colspan="3" rowspan="2">
			<!--img src="img/close_cash_75.png" width="29" height="19" alt=""-->
			<input type="text" onchange="calcAmount('hundreds')" name="hundreds_qty" id="hundreds_qty"  value="<%=hundreds%>"
            style="width: 29px; height: 19px; background: url(img/close_cash_75.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td rowspan="2">
			<!--img src="img/close_cash_76.png" width="60" height="19" alt=""-->
			<input type="text" onchange="calcQty('hundreds')" name="hundreds_amount" id="hundreds_amount"  value="<%=hundreds_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 60px; height: 19px; background: url(img/close_cash_76.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="3" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="img/close_cash_77.png"  width="93" height="19" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_78.png" width="59" height="19" alt=""-->
			<input type="text" id="payin" value="<%=total_payin.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="width: 59px; height: 19px; background: url(img/close_cash_78.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/close_cash_79.png" width="29" height="19" alt=""></td>
		<td rowspan="2">
			<!--img src="img/close_cash_80.png" width="43" height="19" alt=""-->
			<input type="text" style="width: 43px; height: 19px; background: url(img/close_cash_80.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2" rowspan="2">
			<!--img src="img/close_cash_81.png" width="46" height="19" alt=""-->
			<input type="text" style="width: 46px; height: 19px; background: url(img/close_cash_81.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="16" alt=""></td>
	</tr>
	<tr>
		<td colspan="3" rowspan="2">
			<img src="img/close_cash_82.png" width="82" height="23" alt=""></td>
		<td colspan="2" rowspan="2">
			<!--img src="img/close_cash_83.png" width="64" height="23" alt=""-->
			<input type="text" name="total" id="total" value="<%=total_amnt%>"
            style="width: 64px; height: 23px; background: url(img/close_cash_83.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="3" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/close_cash_84.png" width="93" height="20" alt=""></td>
		<td>
			<!--img src="img/close_cash_85.png" width="59" height="20" alt=""-->
			<input type="text" id="payout" value="<%=total_payout.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"
            style="width: 59px; height: 20px; background: url(img/close_cash_85.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2">
			<img src="img/close_cash_86.png" width="29" height="20" alt=""></td>
		<td>
			<!--img src="img/close_cash_87.png" width="43" height="20" alt=""-->
			<input type="text" style="width: 43px; height: 20px; background: url(img/close_cash_87.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td colspan="2">
			<!--img src="img/close_cash_88.png" width="46" height="20" alt=""-->
			<input type="text" style="width: 46px; height: 20px; background: url(img/close_cash_88.png); padding: 2px 2px 0px 2px; border: 0; "/>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="20" alt=""></td>
	</tr>
	<tr>
		<td colspan="5" rowspan="2">
			<img src="img/close_cash_89.png" width="146" height="48" alt=""></td>
		<td colspan="7">
			<img src="img/close_cash_90.png" width="270" height="27" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="27" alt=""></td>
	</tr>
	<tr>
		<td colspan="3">
			<img src="img/close_cash_91.png" width="176" height="21" alt=""></td>
		<td colspan="4">
			<!--img src="img/close_cash_92.png" width="94" height="21" alt=""-->
			<input type="image" onclick="saveCashDrawing(1);" src="img/close_cash_92.png" />
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="21" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/spacer.gif" width="57" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="18" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="7" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="4" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="60" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="93" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="59" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="24" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="5" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="43" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="12" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="34" height="1" alt=""></td>
		<td></td>
	</tr>
</table>
</div>
--%>
<script>
  Custom6.init();
  calcQty('pennies');
  totalCalc('cash');
</script>
