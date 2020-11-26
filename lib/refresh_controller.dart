import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class RefreshController extends RiveAnimationController<RuntimeArtboard> {

  RuntimeArtboard _artboard;

  /// Our four different animations
  LinearAnimationInstance _idle;
  LinearAnimationInstance _pull;
  LinearAnimationInstance _trigger;
  LinearAnimationInstance _loading;

  /// Values from CupertinoSliverRefreshControl builder function
  RefreshIndicatorMode refreshState;
  double pulledExtent;
  double triggerThreshold;
  double refreshIndicatorExtent;

  double get _pullPos {
    return pulledExtent / triggerThreshold;
  }

  @override
  bool init(RuntimeArtboard artboard) {

    _artboard = artboard;
    _idle = artboard.animationByName('Idle');
    _pull = artboard.animationByName('Pull');
    _trigger = artboard.animationByName('Trigger');
    _loading = artboard.animationByName('Loading');

    _pull.time = _pull.animation.enableWorkArea
      ? _pull.animation.workEnd / _pull.animation.fps
      : _pull.animation.duration / _pull.animation.fps;

    isActive = true;
    return _idle != null;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {

    // Idle animation
    _idle.animation.apply(_idle.time, coreContext: artboard);
    _idle.advance(elapsedSeconds);

    // Pull animation
    if (_trigger.time == 0) {
      _pull.animation.apply(_pull.time * _pullPos, coreContext: artboard);
    }

    // Trigger animation
    if (refreshState == RefreshIndicatorMode.refresh ||
        refreshState == RefreshIndicatorMode.armed) {      
      _trigger.animation.apply(_trigger.time, coreContext: artboard);
      _trigger.advance(elapsedSeconds);
      
      // Loading animation
      if (_trigger.time >= _trigger.animation.workEnd / _trigger.animation.fps) {
        _loading.animation.apply(_loading.time, coreContext: artboard);
        _loading.advance(elapsedSeconds);
      }
    }
  }

  void reset() {
    if (pulledExtent != null && triggerThreshold != null) {
      if (pulledExtent < triggerThreshold) {

        final triggerStartFrame = _trigger.animation.enableWorkArea ? _trigger.animation.workStart : 0;
        _trigger.time = triggerStartFrame.toDouble() / _trigger.animation.fps;

        final loadingStartFrame = _loading.animation.enableWorkArea ? _loading.animation.workStart : 0;
        _loading.time = loadingStartFrame.toDouble() / _loading.animation.fps;
        
        _loading.animation.apply(_loading.time, coreContext: _artboard);
        _trigger.animation.apply(_trigger.time, coreContext: _artboard);
        _pull.animation.apply(0, coreContext: _artboard);
      }
    }
  }

  @override 
  void dispose() {}

  @override
  void onActivate() {}

  @override
  void onDeactivate() {}
}