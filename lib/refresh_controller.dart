import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class RefreshController extends RiveAnimationController<RuntimeArtboard> {

  LinearAnimationInstance _idleAnimation;
  LinearAnimationInstance _pullAnimation;
  LinearAnimationInstance _triggerAnimation;
  LinearAnimationInstance _loadingAnimation;

  RefreshIndicatorMode refreshState;
  double pulledExtent;
  double refreshTriggerPullDistance;
  double refreshIndicatorExtent;

  RuntimeArtboard _artboard;
  bool isRefreshing = false;
  bool completedPull = false;

  @override
  bool init(RuntimeArtboard artboard) {

    _artboard = artboard;
    _idleAnimation = getInstance(artboard, animationName: 'Idle');
    _pullAnimation = getInstance(artboard, animationName: 'Pull');
    _triggerAnimation = getInstance(artboard, animationName: 'Trigger');
    _loadingAnimation = getInstance(artboard, animationName: 'Loading');

    isActive = true;
    return _idleAnimation != null;
  }

  LinearAnimationInstance getInstance(RuntimeArtboard artboard, { String animationName }) {
    var animation = artboard.animations.firstWhere(
      (animation) =>
          animation is LinearAnimation && animation.name == animationName,
      orElse: () => null,
    );
    if (animation != null) {
      return LinearAnimationInstance(animation as LinearAnimation);
    }
    return null;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {

    // Idle animation
    _idleAnimation.animation.apply(_idleAnimation.time, coreContext: artboard);
    if (!_idleAnimation.advance(elapsedSeconds)) {
      isActive = false;
    }

    // Pull animation
    double animationPosition = pulledExtent / refreshTriggerPullDistance;
    // animationPosition *= animationPosition;
    
    if (!completedPull && _pullAnimation.time >= _pullAnimation.animation.duration  / _pullAnimation.animation.fps) {
      completedPull = true;
    }

    if (!isRefreshing || !completedPull) {
      _pullAnimation.animation.apply(_pullAnimation.time * animationPosition, coreContext: artboard);
      _pullAnimation.advance(elapsedSeconds);
    }

    // Trigger animation
    if (refreshState == RefreshIndicatorMode.refresh ||
        refreshState == RefreshIndicatorMode.armed) {      
      _triggerAnimation.animation.apply(_triggerAnimation.time, coreContext: artboard);
      _triggerAnimation.advance(elapsedSeconds);
      
      // Loading animation
      if (_triggerAnimation.time >= _triggerAnimation.animation.workEnd / _triggerAnimation.animation.fps) {
        _loadingAnimation.animation.apply(_loadingAnimation.time, coreContext: artboard);
        _loadingAnimation.advance(elapsedSeconds);
      }
    }
  }

  void scrollDidEnd() {
    if (pulledExtent != null && refreshTriggerPullDistance != null) {
      if (pulledExtent < refreshTriggerPullDistance) {
        final triggerStartFrame = (_triggerAnimation.animation.enableWorkArea ? _triggerAnimation.animation.workStart : 0);
        _triggerAnimation.time = triggerStartFrame.toDouble() / _triggerAnimation.animation.fps;
        final loadingStartFrame = (_loadingAnimation.animation.enableWorkArea ? _loadingAnimation.animation.workStart : 0);
        _loadingAnimation.time = loadingStartFrame.toDouble() / _loadingAnimation.animation.fps;
        _loadingAnimation.animation.apply(_loadingAnimation.time, coreContext: _artboard);
        _triggerAnimation.animation.apply(_triggerAnimation.time, coreContext: _artboard);
        _pullAnimation.animation.apply(0, coreContext: _artboard);
        isRefreshing = false;
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