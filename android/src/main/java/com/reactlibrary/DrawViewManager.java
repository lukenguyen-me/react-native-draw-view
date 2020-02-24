package com.reactlibrary;

import android.graphics.Color;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.infer.annotation.Assertions;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;

public class DrawViewManager extends SimpleViewManager<DrawView> {
    private static final String REACT_CLASS = "DrawView";
    public static final int COMMAND_RESET = 1;
    public static final int COMMAND_SAVE = 2;

    @NonNull
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @NonNull
    @Override
    protected DrawView createViewInstance(@NonNull ThemedReactContext reactContext) {
        return new DrawView(reactContext);
    }

    @ReactProp(name = "color")
    public void setColor(DrawView view, String color) {
        int parseColor = Color.parseColor(color);
        view.setColor(parseColor);
    }

    @ReactProp(name = "strokeWidth")
    public void setStrokeWidth(DrawView view, int value) {
        view.setStrokeWidth(value*2);
    }

    @Override
    public void receiveCommand(
            DrawView view,
            int commandType,
            @Nullable ReadableArray args) {
        Assertions.assertNotNull(view);
        Assertions.assertNotNull(args);
        switch (commandType) {
            case COMMAND_RESET: {
                view.reset();
                return;
            }
            case COMMAND_SAVE: {
                view.saveDrawing();
                return;
            }
            default:
                throw new IllegalArgumentException(
                        String.format(
                                "Unsupported command %d received by %s.",
                                commandType,
                                getClass().getSimpleName()
                        )
                );
        }
    }

    public Map getExportedCustomBubblingEventTypeConstants() {
        MapBuilder.Builder<String, Map> builder = MapBuilder.builder();
        builder.put(
                "onSaved",
                MapBuilder.of(
                        "phasedRegistrationNames",
                        MapBuilder.of("bubbled", "onSaved")));
        builder.put(
                "onError",
                MapBuilder.of(
                        "phasedRegistrationNames",
                        MapBuilder.of("bubbled", "onError")));
        return builder.build();
    }
}
