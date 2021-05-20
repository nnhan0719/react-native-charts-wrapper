package com.github.wuxudong.rncharts.markers;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import androidx.core.content.res.ResourcesCompat;

import android.provider.CalendarContract;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.github.mikephil.charting.charts.Chart;
import com.github.mikephil.charting.components.MarkerView;
import com.github.mikephil.charting.data.CandleEntry;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.utils.MPPointF;
import com.github.mikephil.charting.utils.Utils;
import com.github.wuxudong.rncharts.R;
import com.github.wuxudong.rncharts.utils.BridgeUtils;

import java.util.List;
import java.util.Map;

import static android.content.ContentValues.TAG;

public class RNRectangleMarkerView extends MarkerView {

    private TextView tvContent, tvTitle;
    private ImageView dotUp, dotBottom, arrowUp, arrowDown;
    private LinearLayout markerContent;
    private Drawable backgroundLeft = ResourcesCompat.getDrawable(getResources(), R.drawable.maker_down_left, null);
    private Drawable background = ResourcesCompat.getDrawable(getResources(), R.drawable.base_maker, null);
    private Drawable backgroundRight = ResourcesCompat.getDrawable(getResources(), R.drawable.maker_down_right, null);

    private Drawable backgroundTopLeft = ResourcesCompat.getDrawable(getResources(), R.drawable.maker_up_left, null);
    private Drawable backgroundTop = ResourcesCompat.getDrawable(getResources(), R.drawable.base_maker, null);
    private Drawable backgroundTopRight = ResourcesCompat.getDrawable(getResources(), R.drawable.maker_up_right, null);

    private int digits = 0;

    public RNRectangleMarkerView(Context context) {
        super(context, R.layout.rectangle_marker);
        tvContent = findViewById(R.id.rectangle_tvContent);
        tvTitle = findViewById(R.id.rectangle_tvTitle);

        markerContent = findViewById(R.id.markerContent);
        arrowUp = findViewById(R.id.arrowUp);
        arrowDown = findViewById(R.id.arrowDown);
        dotUp = findViewById(R.id.dotTop);
        dotBottom = findViewById(R.id.dotBottom);
    }

    public void setDigits(int digits) {
        this.digits = digits;
    }


    @Override
    public void refreshContent(Entry e, Highlight highlight) {
        String text;
        String title = "";

        if(e == null){
            super.refreshContent(null, highlight);
            return;
        }

        if (e instanceof CandleEntry) {
            CandleEntry ce = (CandleEntry) e;
            text = Utils.formatNumber(ce.getClose(), digits, false);
        } else {
            text = Utils.formatNumber(e.getY(), digits, false);
        }

        if (e.getData() instanceof Map) {
            if (((Map) e.getData()).containsKey("marker")) {
                Object marker = ((Map) e.getData()).get("marker");
                Object titleMarker = ((Map) e.getData()).get("title");
                text = marker.toString();
                title = titleMarker != null ? titleMarker.toString() : "";
                if (highlight.getStackIndex() != -1 && marker instanceof List) {
                    text = ((List) marker).get(highlight.getStackIndex()).toString();
                }

            }
        }

        tvContent.setText(text);
        tvTitle.setText(title);

        super.refreshContent(e, highlight);
    }

    @Override
    public MPPointF getOffset() {
        return new MPPointF(-(getWidth() / 2), -getHeight());
    }

    @Override
    public MPPointF getOffsetForDrawingAtPoint(float posX, float posY) {
        MPPointF offset = getOffset();
        MPPointF offset2 = new MPPointF();

        offset2.x = offset.x;
        offset2.y = offset.y;
        Chart chart = getChartView();

        float width = getWidth();
        if (posX + offset2.x < 0) {
            offset2.x = BridgeUtils.pxFromDp(this.getContext(), -6);
            if (posY + offset2.y < 0) {
                offset2.y = BridgeUtils.pxFromDp(this.getContext(), -6);
                markerContent.setBackground(backgroundTopLeft);
                dotBottom.setVisibility(INVISIBLE);
                arrowDown.setVisibility(INVISIBLE);

                arrowUp.setVisibility(INVISIBLE);
                dotUp.setVisibility(VISIBLE);
                arrowUp.setScaleType(ImageView.ScaleType.FIT_START);
                dotUp.setScaleType(ImageView.ScaleType.FIT_START);
            } else {
                offset2.y += BridgeUtils.pxFromDp(this.getContext(), 6);
                markerContent.setBackground(backgroundLeft);
                arrowUp.setVisibility(INVISIBLE);
                dotUp.setVisibility(INVISIBLE);

                arrowDown.setVisibility(INVISIBLE);
                dotBottom.setVisibility(VISIBLE);
                arrowDown.setScaleType(ImageView.ScaleType.FIT_START);
                dotBottom.setScaleType(ImageView.ScaleType.FIT_START);
            }

        } else if (chart != null && posX + width + offset2.x > chart.getWidth()) {
            offset2.x = -(width - BridgeUtils.pxFromDp(this.getContext(), 6));

            if (posY + offset2.y < 0) {
                offset2.y = BridgeUtils.pxFromDp(this.getContext(), -6);
                markerContent.setBackground(backgroundTopRight);
                dotBottom.setVisibility(INVISIBLE);
                arrowDown.setVisibility(INVISIBLE);

                arrowUp.setVisibility(INVISIBLE);
                dotUp.setVisibility(VISIBLE);
                arrowUp.setScaleType(ImageView.ScaleType.FIT_END);
                dotUp.setScaleType(ImageView.ScaleType.FIT_END);
            } else {
                offset2.y += BridgeUtils.pxFromDp(this.getContext(), 6);
                markerContent.setBackground(backgroundRight);
                dotUp.setVisibility(INVISIBLE);
                arrowUp.setVisibility(INVISIBLE);

                dotBottom.setVisibility(VISIBLE);
                arrowDown.setVisibility(INVISIBLE);
                arrowDown.setScaleType(ImageView.ScaleType.FIT_END);
                dotBottom.setScaleType(ImageView.ScaleType.FIT_END);
            }
        } else {
            if (posY + offset2.y < 0) {
                offset2.y = BridgeUtils.pxFromDp(this.getContext(), -6);
                markerContent.setBackground(backgroundTop);
                arrowDown.setVisibility(INVISIBLE);
                dotBottom.setVisibility(INVISIBLE);

                arrowUp.setVisibility(VISIBLE);
                dotUp.setVisibility(VISIBLE);
                arrowUp.setScaleType(ImageView.ScaleType.FIT_CENTER);
                dotUp.setScaleType(ImageView.ScaleType.FIT_CENTER);
            } else {
                offset2.y += BridgeUtils.pxFromDp(this.getContext(), 6);
                markerContent.setBackground(background);
                dotUp.setVisibility(INVISIBLE);
                arrowUp.setVisibility(INVISIBLE);

                arrowDown.setVisibility(VISIBLE);
                dotBottom.setVisibility(VISIBLE);
                arrowDown.setScaleType(ImageView.ScaleType.FIT_CENTER);
                dotBottom.setScaleType(ImageView.ScaleType.FIT_CENTER);
            }
        }
        super.refreshContent(null, new Highlight(0,0,-1));
        return offset2;
    }

    public TextView getTvContent() {
        return tvContent;
    }

    public void setTooltipBackground(int color) {
        markerContent.setBackgroundTintList(ColorStateList.valueOf(color));

        arrowUp.setImageDrawable(getResources().getDrawable(color == Color.parseColor("#D6F5E4") ? R.drawable.ic_up : R.drawable.ic_up_red));
        arrowDown.setImageDrawable(getResources().getDrawable(color == Color.parseColor("#D6F5E4") ? R.drawable.ic_down : R.drawable.ic_down_red));
    }

    public void setTitleColor(int color) {
        tvTitle.setTextColor(color);
    }

    public void setDotColor(boolean isCredit) {
        dotUp.setImageDrawable(getResources().getDrawable(isCredit ? R.drawable.ic_dot_credit : R.drawable.ic_dot_debit));
        dotBottom.setImageDrawable(getResources().getDrawable(isCredit ? R.drawable.ic_dot_credit : R.drawable.ic_dot_debit));
    }
}