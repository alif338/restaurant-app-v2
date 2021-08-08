package com.example.restaurant_app;

import android.graphics.drawable.Drawable;

import io.flutter.embedding.android.DrawableSplashScreen;
import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.android.SplashScreen;

public class MyFlutterFragment extends FlutterFragment {
    @Override
    public SplashScreen provideSplashScreen() {
        Drawable splash = getResources().getDrawable(R.drawable.splash_screen);
        return new DrawableSplashScreen(splash);
    }

}